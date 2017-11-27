#!bash

# add to timing tasks before use by the following command
# crontab -e

# cd blog-hexo path
cd ~/git/github/blog-hexo

# pull latest code
git pull

# delete local hexo database
hexo clean

# generate blog folders and files
hexo g

# delete old blog folders and files
rm -rf /usr/share/nginx/html/hi/blog/*

# copy new blog folders and files to nginx html path
cp -R public/* /usr/share/nginx/html/hi/blog/
