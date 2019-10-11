#!/bin/bash

config_files="$(ls -aF | grep -oE ".(vim|tmux).*")"
for file in $config_files
do
	ln -s -f $PWD/$file $HOME/
done

#tmux configuration expects $TERM to be set to "xterm-256color" outside of tmux
if [ "$TERM" != "xterm-256color" ]
then
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
