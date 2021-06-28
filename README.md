# Aria2-AriaNg
[![Docker Build Status](https://img.shields.io/docker/cloud/build/jinlife/aria2-ariang.svg)](https://hub.docker.com/r/jinlife/aria2-ariang/)
[![Docker Pulls](https://img.shields.io/docker/pulls/jinlife/aria2-ariang.svg)](https://hub.docker.com/r/jinlife/aria2-ariang/)
[![Layers](https://images.microbadger.com/badges/version/jinlife/aria2-ariang.svg)](https://microbadger.com/images/jinlife/aria2-ariang)
[![Version](https://images.microbadger.com/badges/image/jinlife/aria2-ariang.svg)](https://microbadger.com/images/jinlife/aria2-ariang)

Alpine + Aria2 + Aira-Ng web UI. Built-in daily auto update bt trackers.

## Brief Introduction
* Forked from https://github.com/colinwjd/aria2-ariang.git
* Use Apline:edge as base image, full image only **21Mb**.
* You can edit aria2 config file out of the image because webUI cannot save changes to conf file. 
* Daily auto update the bt-trackers from https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt. 
* Use Aria-Ng as aria2 web ui, it seems much more beautiful.
* Use darkhttpd as http server, it's very small(Only 36K after complied) and easy to use.

## Build
```
git clone https://github.com/jinlife/aria2-ariang.git
cd aria2-ariang
docker build -t jinlife/aria2-ariang .
```

## Auto build in Docker Hub
https://hub.docker.com/r/jinlife/aria2-ariang

## Install
1. Mount `/DOWNLOAD_DIR` to `/aria2/downloads` and `/CONFIG_DIR` to `/aria2/conf`. When starting container, it will create  `aria2.conf` file with default settings.
2. Mapping ports:
  * 6800 for aira2 service
  * 80 for Aria-Ng http service
  * 8080 for downloads directory http service
3. Set your secret code use "SECRET" variable, this will append `rpc-secret=xxx` to aira2.conf file.

Run command like below(You may need to change the ports).
```
docker run --name aria2-ariang \
-p 6800:6800 -p 6880:80 -p 6888:8080 \
-v /DOWNLOAD_DIR:/aria2/downloads \
-v /CONFIG_DIR:/aria2/conf \
-e SECRET=YOUR_SECRET_CODE jinlife/aria2-ariang
```
After finished, open http://serverip:6880/ in your browser for visiting Aria-Ng home page, open http://serverip:6888/ to browser your downloads folder.

## Config for Synology (群晖)
1. Port
  * Set local port 10080, container port 80.  type tcp
  * Set local port 16800, container port 6800. type tcp
  * Set local port 51413, container port 51413. type tcp
  * Set local port 51413, container port 51413. type udp
  * If the server is behind router, please expose the port 51413 at least to listen.
2. Folder
  * Set folder docker/Aria2/config, load as /aria2/conf, read and write permission
  * Set folder video/downloads, load as /aria2/downloads, read and write permission
3. Token
  * Set environment variable. Name is SECRET, value is YOUR_SECRET_CODE
4. TimeZone (Default is Etc/UTC, optional change)
  * Set environment varialbe. Name is TZ, value is Asia/Shanghai

After start the container, open http://serverip:10080 in your browser for visiting Aria-Ng home page.  Input the correct serverip, 16800 and SECRET value in the Aria-Ng settings page.

## How to update in docker of Synology
1. Stop the jinlife/aria2-ariang container.
2. In the Registry, search jinlife/aria2-ariang and download latest one. Wait for download finished.
3. In the Container, right click to Clean(清除) the jinlife/aria2-ariang container.
4. Start the container. You will get the latest image running now.