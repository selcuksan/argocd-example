#!/bin/bash

# exit when any command fails
set -e
new_ver=$1
echo "new version: $new_ver"

# Simulate release of the new docker images
docker tag nginx:1.23.3 selcuksan/nginx:$new_ver

# Push new version to dockerhub
docker push selcuksan/nginx:$new_ver

# Create temporary folder
tmp_dir=$(mktemp -d)
echo $tmp_dir

git clone https://github.com/selcuksan/argocd-example.git $tmp_dir


# Update image tag
sed -i '' -e "s/selcuksan\/nginx:.*/selcuksan\/nginx:$new_ver/g" $tmp_dir/my-app/1-deployment.yaml
# Commit and push
cd $tmp_dir
git add .
git commit -m "Update image to $new_ver"
git push

rm -rf $tmp_dir