#!/bin/bash

config_files="$(ls -aF | grep -oE ".(vim|tmux).*")"
for file in $config_files
do
	ln -s -f $PWD/$file $HOME/
done

if [ "$TERM" != "xterm-256color" ]
then
	echo 'export TERM="xterm-256color"' >> ~/.bashrc
	echo ".bashrc has been updated. Reload using one of the lines below:"
	echo ""
	echo -e "source ~/.bashrc"
	echo -e ". ~/.bashrc"
	echo -e "exec bash"
	
fi
