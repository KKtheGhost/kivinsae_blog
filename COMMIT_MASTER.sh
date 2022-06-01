#!/bin/bash

echo "Please input commit info in AngularJS form (<type>(topic): details):"
read commit
git add .
git commit -m "${commit}"
git push git@github.com:KKtheGhost/kivinsae_blog.git master
