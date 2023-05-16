#!/bin/bash

npm install

rm -rf node_modules/hexo-theme-landscape
cp -rf hexo-theme-landscape node_modules/hexo-theme-landscape
cp -rf _config.module.yml _config.yml
cp -rf node_modules/hexo-theme-landscape/_config.module.yml node_modules/hexo-theme-landscape/_config.yml

sed -i "s/TAG_ENCRYPT_PSWD/$ENCRYPT_PSWD/g" _config.yml
sed -i "s/TAG_PRIVATE_PSWD/$PRIVATE_PSWD/g" _config.yml
sed -i "s/LEANCLOUD_APPID/$LC_APPID/g" node_modules/hexo-theme-landscape/_config.yml
sed -i "s/LEANCLOUD_APPKEY/$LC_APPKEY/g" node_modules/hexo-theme-landscape/_config.yml

./node_modules/hexo/bin/hexo clean
./node_modules/hexo/bin/hexo generate

cp -rf ads.txt ./public/
