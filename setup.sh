#!/bin/bash
#tmux attach -t ws || tmux new -s ws

function plugins_setup {
	# Get latest plug.vim 
	echo "getting latest vim-plug..."
	wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -O plug.vim &> /dev/null
	# adding plug.vim to autoload
	mkdir ~/.vim/autoload -p
	ln -s -f $PWD/plug.vim $HOME/.vim/autoload/
	mkdir ~/.vim/plugged -p
	echo 'let enable_plugins="true"' > ./.vimrc.local
	echo -e "\nrun :PlugInstall in vim after this setup"
}

# making .vimrc.local file (plugin option)
read -p "Setup plugins (y/n)?" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	plugins_setup
elif [[ $REPLY =~ ^[Nn]$ ]]; then
	echo 'let enable_plugins="false"' > ./.vimrc.local && echo ""
fi

# creating syslinks of config files to user's home directory
#config_files="$(ls -aF | grep -oE ".(vimrc|tmux|inputrc).*")" #inputrc is causing problems with ctrl-arrow to move back by word on the cli
config_files="$(ls -aF | grep -oE ".(vimrc|tmux|bashrc).*")" 
for file in $config_files
do
	if [ -f "$HOME/$file" ] && [ "$(readlink $HOME/$file)" != "$PWD/$file" ]; then
		echo
		read -p "$file exist in home direcotory. Overwrite (y/n)?" -n 1 -r
		if [[ $REPLY =~ ^[Yy]$ ]]; then
			ln -s -f $PWD/$file $HOME/
		fi
	else
		ln -s -f $PWD/$file $HOME/
	fi
done
echo "files have been linked to home directory"

# adding additional bash (shell) settings
if [[ "$SHELL" == *"bash"* ]]; then
	if ! grep -q "bashrc.local" $HOME/.bashrc; then 
		echo 'source $HOME/.bashrc.local' >> ~/.bashrc
		echo ".bashrc has been updated. Reload using the command below"
		echo ""
		echo -e "source ~/.bashrc"
	fi
#		echo -e ". ~/.bashrc"
#		echo -e "exec bash"
elif [[ "$SHELL" == *"zsh"* ]]; then
	if ! grep -q "bashrc.local" $HOME/.zshrc; then 
		echo 'source $HOME/.bashrc.local' >> ~/.zshrc
		echo ".zshrc has been updated. Reload using the command below"
		echo ""
		echo -e "source ~/.zshrc"
	fi
else
	echo 'source ~/bashrc.local'	
fi
