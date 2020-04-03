#!/bin/bash
# ex
# ./parse_vim.sh <PATH> --rdb

CS_FILE=cscope.file
PARSE_BK=~/parsing_bk
PARSE_PATH=$1

if [ -z "$PARSE_PATH" ]; then
    #print usage
    echo "please input the path for parsing"
    echo "parse_vim.sh <PATH> [OPT]"
    echo "OPT: --cdb(default) --rdb"
    exit 1
fi

if [ -n "$2" ]; then
    case $2 in
    #clean PARSE_DB
    --cdb)
        PARSE_OPT="--CLEAN_DB"
    ;;
    #remain PARSE_DB
    --rdb)
        PARSE_OPT="--REMAIN_DB"
    ;;
    *)
        PARSE_OPT="--CLEAN_DB"
    ;;
    esac
else
    PARSE_OPT="--CLEAN_DB"
fi

################
# main procedure
################
rm $PARSE_PATH/tags
rm $PARSE_PATH/cscope*

echo "backup data"
if [ $PARSE_OPT == "--CLEAN_DB" ]; then
    if  [ -d $PARSE_BK ]; then
        rm -rf $PARSE_BK
        mkdir $PARSE_BK
    fi
fi
mv $PARSE_PATH/*.vim $PARSE_BK

#parsing process
echo "start parsing"
find $PARSE_PATH -name "*.aidl" \
    -o -name "*.cc" \
    -o -name "*.h" \
    -o -name "*.c" \
    -o -name "*.cpp" \
    -o -name "*.java" \
    -o -name "*.js" \
    -o -name "*.mk" \
    -o -name "*.m" \
    > $CS_FILE
ctags -R --exclude=.svn --exclude=.git --exclude=.vim --exclude=out
cscope -bkq -i $CS_FILE
#cscope -Rbk -i $CS_FILE


echo "restore backup data"
mv $PARSE_BK/*.vim $PARSE_PATH
if [ $PARSE_OPT == "CLEAN_DB" ]; then
    rm -rf $PARSE_BK
fi

