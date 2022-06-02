#!/bin/bash

# Pull latest master branch
cd /opt/hexo && git pull origin master
# Renew config file
rm _config.yml
ENCRYPT_PSWD=$(cat /root/.hexo_encrypt | grep ENCRYPT | awk -F':' '{print $2}')
PRIVATE_PSWD=$(cat /root/.hexo_encrypt | grep PRIVATE | awk -F':' '{print $2}')
sed -i "s/TAG_ENCRYPT_PSWD/$ENCRYPT_PSWD/g" _config.module.yml
sed -i "s/TAG_PRIVATE_PSWD/$PRIVATE_PSWD/g" _config.module.yml
cp -rf _config.module.yml _config.yml
#
git lfs fetch --all origin master && git lfs pull
exec >> /var/log/nginx/syntax_check.log 2>&1

echo "============================================"
echo $(date +"%F %T")

/usr/bin/hexo clean		    # Clear the existing public files
/usr/bin/hexo generate		# Generate new version of public files
systemctl restart hexo		# Only renew the local hexo server. For PoC

# Sync the new generated public to nginx root dir.
cp -r /opt/hexo/public/* /var/www/hexo/public/
# Add nginx syntax test result to log file
nginx -t
# Reload nginx
nginx -s reload
