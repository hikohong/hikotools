#!/bin/bash

find . -name .*.swp -exec rm -rf {} \;
find . -name ._.DS_Store* -exec rm -rf {} \;
find . -name .DS_Store* -exec rm -rf {} \;
