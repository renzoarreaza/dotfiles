#!/bin/bash

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

#read -p "Setup plugins (y/n)?" choice
#case "$choice" in 
#	y|Y ) plugins_setup;;
#	n|N ) echo 'let enable_plugins="false"' > ./.vimrc.local && echo "";;
#	* ) echo "invalid";;
#esac

read -p "Setup plugins (y/n)?" -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
	plugins_setup
elif [[ $REPLY =~ ^[Nn]$ ]]; then
	echo 'let enable_plugins="false"' > ./.vimrc.local && echo ""
fi


# creating syslinks of config files to user's home directory
#config_files="$(ls -aF | grep -oE ".(vimrc|tmux|inputrc).*")"
config_files="$(ls -aF | grep -oE ".(vimrc|tmux).*")" #inputrc is causing problems with ctrl-arrow to move back by word on the cli
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


#tmux configuration expects $TERM to be set to "xterm-256color" outside of tmux
if [ "$TERM" != "xterm-256color" ]
then
	# $SHELL has the user's default shell
	if [[ "$SHELL" == *"bash"* ]]; then
		echo 'export TERM="xterm-256color"' >> ~/.bashrc
		echo ".bashrc has been updated. Reload using the command below"
		echo ""
		echo -e "source ~/.bashrc"
#		echo -e ". ~/.bashrc"
#		echo -e "exec bash"
	elif [[ "$SHELL" == *"zsh"* ]]; then
		echo 'export TERM="xterm-256color"' >> ~/.zshrc
		echo ".zshrc has been updated. Reload using the command below"
		echo ""
		echo -e "source ~/.zshrc"
	else
		echo 'set $TERM to "xterm-256color"'	
	fi
fi
#echo "Done!"
