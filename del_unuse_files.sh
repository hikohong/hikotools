#!/bin/bash
# created by Hiko Hong on 2015/05/07
# hikohong@gmail.com

for file in *.bak *.swp .*.swp ._.DS_Store* .DS_Store* Thumbs.db
do
	find . -name $file -exec rm -rfv {} \;
done
