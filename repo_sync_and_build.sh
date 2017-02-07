#!/bin/bash
#repo init -u ssh://git@10.1.200.20/fr/manifest.git -m r14000.1.xml
#repo init -u ssh://git@10.1.200.20/fr/manifest.git -m r17000.1.xml
repo sync -j12
#source build/envsetup.sh
#lunch frontrow_wear-userdebug
#build FR OS
./ubnt/build.sh frontrow_wear-userdebug
#build original apq8053
#./ubnt/build.sh msm8953_64-userdebug

