#!/bin/bash
#declare -a symb_flies=(`find . -type l`)
declare -a symb_flies=(`ls`)
#echo "debug: $symb_flies"

#searching symbolic links
echo "folder count : ${#symb_flies[@]}"
for ((i=0; i<${#symb_flies[@]}; i++)); do
    if [ -d "${symb_flies[$i]}" ]; then
        cd "${symb_flies[$i]}"
        echo "current dir: `pwd`"
        if [ -d ".git" ]; then
            git pull --rebase
            echo "hit!"
        fi
        cd ../
    fi
done


