#!/bin/bash
# Please be using root login first, then execute this script

CURR_ACC_NAME=ubnt
NEW_ACC_NAME=hikohong
USER_GROUP=captain

#change comment
sudo usermod -c "Vulcan DB" $CURR_ACC_NAME

#change home directory name
sudo mv /home/$CURR_ACC_NAME /home/$NEW_ACC_NAME
sudo usermod -d /home/$NEW_ACC_NAME $CURR_ACC_NAME

#change user groud
sudo groupadd $USER_GROUP
sudo usermod -g $USER_GROUP $CURR_ACC_NAME

#change user login name
sudo usermod -l $NEW_ACC_NAME $CURR_ACC_NAME
