---
title: 在 Ubuntu 通过 nginx 配置 https
tags:
  - Linux
  - Ubuntu
  - https
date: 2017-11-02 19:25:05
categories: https
---

{% cq %}sudo nginx -s reload{% endcq %}

<!-- more -->

由于微信小程序之前的服务器即将到期，现迁移服务器应用到一台 ubuntu 服务器，由于之前服务器是 centos ，迁移过程多少出现了些问题。以后用了 docker 就不会有这样的问题了吧，不过只是刚开始学 docker ，以后再弄吧。

### 环境
#### centos
```bash
[root@VM_11_73_centos ~]# nginx -v
nginx version: nginx/1.10.2
```
#### ubuntu
```bash
ubuntu@VM-214-51-ubuntu:~$ nginx -v
nginx version: nginx/1.10.3 (Ubuntu)
```

### Centos nginx 配置
```bash
user nginx;
worker_processes auto;
error_log /var/log/nginx/error.log;
pid /run/nginx.pid;

# Load dynamic modules. See /usr/share/nginx/README.dynamic.
include /usr/share/nginx/modules/*.conf;

events {
    worker_connections 1024;
}

http {
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 2048;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    # Load modular configuration files from the /etc/nginx/conf.d directory.
    # See http://nginx.org/en/docs/ngx_core_module.html#include
    # for more information.
    include /etc/nginx/conf.d/*.conf;

    server {
        listen       80 default_server;
        listen       [::]:80 default_server;
        server_name  _;
        root         /usr/share/nginx/html;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        location / {
                proxy_pass http://127.0.0.1:8080;
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }

# Settings for a TLS enabled server.

    server {
        listen       443 ssl http2 default_server;
        listen       [::]:443 ssl http2 default_server;
        server_name  _;
        root         /usr/share/nginx/html;

        ssl_certificate "crt file path";
        ssl_certificate_key "key file path";
        ssl_session_cache shared:SSL:1m;
        ssl_session_timeout  10m;
        #        ssl_ciphers HIGH:!aNULL:!MD5;
        ssl_protocols TLSv1 TLSv1.1 TLSv1.2; #按照这个协议配置
        ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:HIGH:!aNULL:!MD5:!RC4:!DHE;#按照这个套件配置
        ssl_prefer_server_ciphers on;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        location / {
                proxy_pass http://127.0.0.1:8080;
        }

        error_page 404 /404.html;
            location = /40x.html {
        }

        error_page 500 502 503 504 /50x.html;
            location = /50x.html {
        }
    }
}
```

### Ubuntu 默认配置
```bash
user www-data;
worker_processes auto;
pid /run/nginx.pid;

events {
        worker_connections 768;
        # multi_accept on;
}

http {
        ##
        # Basic Settings
        ##

        sendfile on;
        tcp_nopush on;
        tcp_nodelay on;
        keepalive_timeout 65;
        types_hash_max_size 2048;
        # server_tokens off;

        # server_names_hash_bucket_size 64;
        # server_name_in_redirect off;

        include /etc/nginx/mime.types;
        default_type application/octet-stream;

        ##
        # SSL Settings
        ##

        ssl_protocols TLSv1 TLSv1.1 TLSv1.2; # Dropping SSLv3, ref: POODLE
        ssl_prefer_server_ciphers on;

        ##
        # Logging Settings
        ##

        access_log /var/log/nginx/access.log;
        error_log /var/log/nginx/error.log;

        ##
        # Gzip Settings
        ##

        gzip on;
        gzip_disable "msie6";

        # gzip_vary on;
        # gzip_proxied any;
        # gzip_comp_level 6;
        # gzip_buffers 16 8k;
        # gzip_http_version 1.1;
        # gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;

        ##
        # Virtual Host Configs
        ##

        include /etc/nginx/conf.d/*.conf;
        include /etc/nginx/sites-enabled/*;
}


#mail {
#       # See sample authentication script at:
#       # http://wiki.nginx.org/ImapAuthenticateWithApachePhpScript
#
#       # auth_http localhost/auth.php;
#       # pop3_capabilities "TOP" "USER";
#       # imap_capabilities "IMAP4rev1" "UIDPLUS";
#
#       server {
#               listen     localhost:110;
#               protocol   pop3;
#               proxy      on;
#       }
#
#       server {
#               listen     localhost:143;
#               protocol   imap;
#               proxy      on;
#       }
#}
```


### 问题一
将 server 节点复制到 `/etc/nginx/nginx.conf` 里，与 `events` 、 `http` 节点同级，执行 `sudo nginx -t -c /etc/nginx/nginx.conf` 报错，如下
```bash
nginx: [alert] could not open error log file: open() "/var/log/nginx/error.log" failed (13: Permission denied)
2017/11/02 19:07:12 [warn] 24890#24890: the "user" directive makes sense only if the master process runs with super-user privileges, ignored in /etc/nginx/nginx.conf:1
2017/11/02 19:07:12 [emerg] 24890#24890: "server" directive is not allowed here in /etc/nginx/nginx.conf:5
nginx: configuration file /etc/nginx/nginx.conf test failed
```

重点是 ` "server" directive is not allowed here in /etc/nginx/nginx.conf` ，`server` 节点不允许配置在那里，很明显不能与 `events` 、 `http` 同级。

### 解决方案
将 `server` 节点配置放到 `http` 节点下。
```bash
events {
    ...
}
http {
    ...
    server {
        ...
    }
}
```
然后执行 `nginx -t -c /etx/nginx/nginx.conf` 仍然报错，这就有了问题二。

### 问题二
执行 `nginx -t -c /etc/nginx/nginx.conf` 报错如下
```bash
nginx: [emerg] a duplicate default server for 0.0.0.0:80 in /etc/nginx/sites-enabled/default:17
nginx: configuration file /etc/nginx/nginx.conf test failed
```

重点是 `a duplicate default server for 0.0.0.0:80` ，对于 80 端口有两多个默认配置，意思就是你特妹的设置了两个监听 80 端口的 server 配置。
于是看到了 http 节点下两句配置语句，意思是将这两处的配置也包含到主配置文件来，这样可能是模块化、配置分工更明确吧。
```bash
include /etc/nginx/conf.d/*.conf;
include /etc/nginx/sites-enabled/*;
```
第一处查得无配置文件。
第二处有一配置文件如下，确实有一个 80 端口配置，自己再配置一个 80 端口造成了冲突。
```bash
server {
        listen 80 default_server;
        listen [::]:80 default_server;

        # SSL configuration
        #
        # listen 443 ssl default_server;
        # listen [::]:443 ssl default_server;
        #
        # Note: You should disable gzip for SSL traffic.
        # See: https://bugs.debian.org/773332
        #
        # Read up on ssl_ciphers to ensure a secure configuration.
        # See: https://bugs.debian.org/765782
        #
        # Self signed certs generated by the ssl-cert package
        # Don't use them in a production server!
        #
        # include snippets/snakeoil.conf;

        root /var/www/html;

        # Add index.php to the list if you are using PHP
        index index.html index.htm index.nginx-debian.html;

        server_name _;

        location / {
                # First attempt to serve request as file, then
                # as directory, then fall back to displaying a 404.
                try_files $uri $uri/ =404;
                proxy_pass http://127.0.0.1:8080;
        }

        # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
        #
        #location ~ \.php$ {
        #       include snippets/fastcgi-php.conf;
        #
        #       # With php7.0-cgi alone:
        #       fastcgi_pass 127.0.0.1:9000;
        #       # With php7.0-fpm:
        #       fastcgi_pass unix:/run/php/php7.0-fpm.sock;
        #}

        # deny access to .htaccess files, if Apache's document root
        # concurs with nginx's one
        #
        #location ~ /\.ht {
        #       deny all;
        #}
}


# Virtual Host configuration for example.com
#
# You can move that to a different file under sites-available/ and symlink that
# to sites-enabled/ to enable it.
#
#server {
#       listen 80;
#       listen [::]:80;
#
#       server_name example.com;
#
#       root /var/www/example.com;
#       index index.html;
#
#       location / {
#               try_files $uri $uri/ =404;
#       }
#}
```

### 解决方案
两种方案，推荐第二种，感觉分工明确还是比较好的。
- 删除 `include /etc/nginx/sites-enabled/*;` 文件后在 `/etc/nginx/nginx.conf` 配置 80 内容
- 在 `include /etc/nginx/sites-enabled/*;` 配置要配置的内容。

执行 `sudo nginx -t -c /etc/nginx/nginx.conf` 出现输出下面内容说明配置成功。
```bash
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```
将 nginx 配置生效
`sudo nginx -s reload`

### 问题三
配置完 端口代理（80->8080） 和 https 后，首页通过 https 可以正常访问 tomcat 首页，但是其他路径就会报 404 。

### 解决方案
猜想 try_files 导致，注释之后就解决了。
try_files /4.html /5.html @qwe;

### 问题四
这是自己的部署的问题，本来的时候数据库跟应用服务器放在同一个服务器，由于 https ，配置数据库链接地址是服务器的域名，而不是 ip 地址，而新的服务器没有数据库，这就造成了下面的错误。
`"Could not create connection to database server. Attempted reconnect 3 times. Giving up."`

### 解决方案
意思是 连接不上数据库，重新配置数据库地址后要重启 tomcat 。


参考
> https://stackoverflow.com/questions/41766195/nginx-emerg-server-directive-is-not-allowed-here
> http://blog.csdn.net/number_chc/article/details/39340603
> https://www.shiyanlou.com/questions/8732
> https://www.digitalocean.com/community/tutorials/how-to-set-up-nginx-with-http-2-support-on-ubuntu-16-04
> http://xy.uyun.cn/post/80.html
