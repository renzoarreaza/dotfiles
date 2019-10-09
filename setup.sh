#!/bin/bash

config_files="$(ls -aF | grep -oE ".(vim|tmux).*")"
for file in $config_files
do
	ln -s -f $PWD/$file $HOME/
done
