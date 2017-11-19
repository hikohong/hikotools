#!/bin/bash
if [ $1 ]; then
    PATH="$1"
else
    echo "please input the file path with parm 1"
    exit 1
fi
if [ $2 ]; then
    SOURCE_EXT=$2
else
    echo "please input the source extension name with parm 2"
    exit 1
fi
if [ $3 ]; then
    TARGET_EXT=$3
else
    echo "please input the target extension name with parm 3"
    exit 1
fi

for file in $PATH/*.$SOURCE_EXT; do
    /bin/mv "$file" "${file%.*}.$TARGET_EXT"
done
