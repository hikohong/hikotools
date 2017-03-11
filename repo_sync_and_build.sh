#!/bin/bash
#repo init -u ssh://git@10.1.200.20/fr/manifest.git -m r14000.1.xml
#repo init -u ssh://git@10.1.200.20/fr/manifest.git -m r17000.1.xml
#repo sync -j12
repo sync -j8
#repo sync --network-only --jobs=8 --current-branch --no-tags
source build/envsetup.sh
#lunch frontrow_wear-userdebug
lunch 34
#build FR OS
#./ubnt/build.sh frontrow_wear-userdebug
#build original apq8053
#./ubnt/build.sh msm8953_64-userdebug
make -j4 2>&1 | tee make.log
