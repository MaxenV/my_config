# Debian + Secure Boot + NVIDIA

Krótka instrukcja konfiguracji Secure Boot na Debianie oraz naprawy sterownika NVIDIA, gdy po włączeniu Secure Boot pojawia się czarny ekran albo brak pulpitu.

## 1. Założenia

Instrukcja dotyczy Debiana uruchamianego w trybie UEFI.

Sprawdzenie UEFI:

```bash
test -d /sys/firmware/efi && echo "UEFI OK" || echo "Brak UEFI"
```

Jeśli pokazuje `Brak UEFI`, Secure Boot nie zadziała w tej konfiguracji.

---

## 2. Instalacja pakietów Secure Boot

W Debianie zainstaluj podpisany bootloader i narzędzia EFI:

```bash
sudo apt update
sudo apt install -y \
  shim-signed \
  shim-helpers-amd64-signed \
  grub-efi-amd64-signed \
  grub-efi-amd64-bin \
  mokutil \
  efibootmgr
```

Następnie zaktualizuj GRUB:

```bash
sudo update-grub
```

---

## 3. Sprawdzenie wpisów bootowania UEFI

Sprawdź wpisy:

```bash
sudo efibootmgr -v
```

Poprawny wpis dla Debiana pod Secure Boot powinien wskazywać na:

```text
\EFI\DEBIAN\SHIMX64.EFI
```

Przykład poprawnego wpisu:

```text
Boot0002* debian ... /File(\EFI\DEBIAN\SHIMX64.EFI)
```

Wpis bezpośrednio na GRUB wygląda tak:

```text
\EFI\DEBIAN\GRUBX64.EFI
```

Pod Secure Boot powinien być używany `SHIMX64.EFI`, nie bezpośredni `GRUBX64.EFI`.

---

## 4. Ustawienie Debiana przez shim jako pierwszy boot

Jeśli wpis Debiana przez shim to np. `Boot0002`, a Windows to `Boot0000`, ustaw kolejność:

```bash
sudo efibootmgr -o 0002,0000
```

Jeżeli chcesz zostawić bezpośredni GRUB jako fallback, można użyć:

```bash
sudo efibootmgr -o 0002,0000,0003
```

Po restarcie sprawdź:

```bash
sudo efibootmgr
```

Poprawny wynik powinien zawierać:

```text
BootCurrent: 0002
BootOrder: 0002,0000,...
Boot0002* debian ... SHIMX64.EFI
```

---

## 5. Włączenie Secure Boot w BIOS/UEFI

Po ustawieniu bootowania przez `shimx64.efi` wejdź do BIOS/UEFI i ustaw:

```text
Secure Boot: Enabled
Secure Boot Mode: Standard
OS Type: Windows UEFI Mode
Restore/Install Factory Default Keys
Microsoft 3rd Party UEFI CA: Enabled
```

Opcja `Microsoft 3rd Party UEFI CA` jest ważna, bo bez niej część komputerów ufa Windowsowi, ale nie ufa linuksowemu `shimx64.efi`.

---

## 6. Sprawdzenie Secure Boot w Debianie

Po uruchomieniu Debiana sprawdź:

```bash
mokutil --sb-state
```

Poprawny wynik:

```text
SecureBoot enabled
```

---

## 7. Sprawdzenie Secure Boot w Windows

W Windows otwórz PowerShell jako administrator i wpisz:

```powershell
Confirm-SecureBootUEFI
```

Wynik:

```powershell
True
```

oznacza, że Secure Boot jest włączony.

Można też sprawdzić przez:

```text
Win + R → msinfo32
```

I znaleźć:

```text
Secure Boot State: On
BIOS Mode: UEFI
```

---

## 8. Problem: Debian startuje do czarnego ekranu po wyborze w GRUB

Jeśli GRUB działa, ale po wybraniu Debiana jest czarny ekran, prawdopodobnym problemem jest sterownik NVIDIA.

W GRUB zaznacz Debiana i naciśnij:

```text
e
```

Znajdź linię zaczynającą się od `linux` i na końcu dopisz:

```text
nomodeset systemd.unit=multi-user.target
```

Potem uruchom system:

```text
Ctrl + X
```

albo:

```text
F10
```

To powinno uruchomić Debiana w trybie terminalowym.

---

## 9. Instalacja/Naprawa NVIDIA przy Secure Boot

Zainstaluj wymagane pakiety:

```bash
sudo apt update
sudo apt install -y \
  dkms \
  mokutil \
  openssl \
  linux-headers-amd64 \
  linux-headers-$(uname -r) \
  nvidia-driver \
  nvidia-kernel-dkms \
  firmware-misc-nonfree
```

Sprawdź DKMS:

```bash
sudo dkms status
```

Jeżeli `dkms` nie działa w fishu, sprawdź pełną ścieżką:

```bash
sudo /usr/sbin/dkms status
```

---

## 10. Podpisanie modułów NVIDIA przez MOK

Przy Secure Boot moduł NVIDIA musi być zaufany. Używa się do tego MOK.

Wygeneruj/importuj klucz:

```bash
sudo dkms generate_mok
sudo mokutil --import /var/lib/dkms/mok.pub
```

Ustaw jednorazowe hasło.

Następnie zrestartuj:

```bash
sudo systemctl reboot
```

---

## 11. Ekran MOK Manager

Po restarcie powinien pojawić się niebieski ekran MOK Manager.

Wybierz:

```text
Enroll MOK
Continue
Yes
```

Następnie wpisz hasło ustawione przy `mokutil --import`.

Ważne: podczas wpisywania hasła często nie widać żadnych znaków ani gwiazdek. Wpisz hasło „na ślepo” i zatwierdź Enterem.

Jeśli klawiatura nie działa na ekranie MOK:

- użyj przewodowej klawiatury USB,
- podepnij ją bezpośrednio do portu USB na komputerze,
- najlepiej użyj portu USB 2.0,
- w BIOS/UEFI wyłącz `Fast Boot`,
- włącz `Legacy USB Support` / `USB Keyboard Support`.

---

## 12. Po poprawnym enrollowaniu MOK

Po wejściu do Debiana wykonaj:

```bash
sudo dkms autoinstall
sudo update-initramfs -u -k all
sudo modprobe nvidia
nvidia-smi
```

Jeśli działa, `nvidia-smi` pokaże tabelę z kartą NVIDIA.

Dodatkowo możesz sprawdzić podpis modułu:

```bash
modinfo nvidia | grep -E "signer|sig_key|sig_hashalgo"
```

---

## 13. Przydatne komendy diagnostyczne

Secure Boot:

```bash
mokutil --sb-state
```

Wpisy UEFI:

```bash
sudo efibootmgr
sudo efibootmgr -v
```

Sterownik NVIDIA:

```bash
nvidia-smi
lsmod | grep -E "nvidia|nouveau"
```

Błędy NVIDIA/Secure Boot:

```bash
sudo journalctl -b -p err --no-pager | grep -iE "nvidia|dkms|module|lockdown|secure"
dmesg | grep -iE "nvidia|lockdown|module verification|secure"
```

Status DKMS:

```bash
sudo dkms status
```

---

## 14. Szybki scenariusz naprawczy

Jeśli po włączeniu Secure Boot Debian nie pokazuje pulpitu:

1. W GRUB dopisz do startu Debiana:

```text
nomodeset systemd.unit=multi-user.target
```

2. Po wejściu do terminala zainstaluj DKMS i NVIDIA:

```bash
sudo apt update
sudo apt install -y dkms mokutil openssl linux-headers-amd64 linux-headers-$(uname -r) nvidia-driver nvidia-kernel-dkms firmware-misc-nonfree
```

3. Importuj MOK:

```bash
sudo dkms generate_mok
sudo mokutil --import /var/lib/dkms/mok.pub
sudo systemctl reboot
```

4. W MOK Manager wybierz:

```text
Enroll MOK → Continue → Yes
```

5. Po restarcie:

```bash
sudo dkms autoinstall
sudo update-initramfs -u -k all
nvidia-smi
```

---

## 15. Oczekiwany stan końcowy

Debian:

```bash
mokutil --sb-state
```

powinno zwrócić:

```text
SecureBoot enabled
```

UEFI:

```bash
sudo efibootmgr
```

powinno pokazywać Debiana przez shim:

```text
BootCurrent: 0002
Boot0002* debian ... SHIMX64.EFI
```

NVIDIA:

```bash
nvidia-smi
```

powinno pokazywać tabelę z kartą graficzną.
