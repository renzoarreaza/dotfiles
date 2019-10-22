#!/bin/bash


function plugins_setup {
	# Get latest plug.vim 
	wget https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim -O plug.vim
	# adding plug.vim to autoload
	mkdir ~/.vim/autoload -p
	ln -s -f $PWD/plug.vim $HOME/.vim/autoload/
	mkdir ~/.vim/plugged -p
	# add plugins.vim to .vimrc
	sed -i "18isource $PWD/plugins.vim" ./.vimrc 
}


read -p "Setup plugins (y/n)?" choice
case "$choice" in 
	y|Y ) plugins_setup;;
	n|N ) echo ;;
	* ) echo "invalid";;
esac


# creating syslinks of config files to user's home directory
config_files="$(ls -aF | grep -oE ".(vimrc|tmux).*")"
for file in $config_files
do
	ln -s -f $PWD/$file $HOME/
done


#tmux configuration expects $TERM to be set to "xterm-256color" outside of tmux
if [ "$TERM" != "xterm-256color" ]
then
	# $SHELL has the user's default shell
	if [[ "$SHELL" == *"bash"* ]]
	then
		echo 'export TERM="xterm-256color"' >> ~/.bashrc
		echo ".bashrc has been updated. Reload using the command below"
		echo ""
		echo -e "source ~/.bashrc"
#		echo -e ". ~/.bashrc"
#		echo -e "exec bash"
	elif [[ "$SHELL" == *"zsh"* ]] 
	then
		echo 'export TERM="xterm-256color"' >> ~/.zshrc
		echo ".zshrc has been updated. Reload using the command below"
		echo ""
		echo -e "source ~/.zshrc"
	else
		echo 'set $TERM to "xterm-256color"'	
	fi
fi
