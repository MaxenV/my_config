auto_completion(){
	git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
}

oh_my_p10k(){
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

	git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k"

	mkdir -p ~/.local/share/fonts
	cd ~/.local/share/fonts
	curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
	unzip -o FiraCode.zip
	rm FiraCode.zip
	fc-cache -f -v
}

requirements_main(){
	sudo apt install zsh git curl 
	auto_completion
}