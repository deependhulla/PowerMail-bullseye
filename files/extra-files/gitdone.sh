#!/bin/sh

# https://gist.github.com/ateucher/4634038875263d10fb4817e5ad3d332f
## use personal access token.

git config --global user.name "Deepen Dhulla"
git config --global user.email "deepen@deependhulla.com"

git config --global credential.helper cache
git config --global credential.helper 'cache --timeout=3600'
# Set the cache to timeout after 1 hour (setting is in seconds)

git add .
git commit -m "update on `date` $1"
#git push origin master
git push 

