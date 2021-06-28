#!/bin/sh
if [ ! -f /aria2/conf/aria2.conf ]; then
	cp /aria2/conf-temp/aria2.conf /aria2/conf/aria2.conf
	if [ $SECRET ]; then
		echo "rpc-secret=${SECRET}" >> /aria2/conf/aria2.conf
	fi
	/update-bt-tracker.sh
fi
if [ ! -f /aria2/conf/dht.dat ]; then
	cp /aria2/conf-temp/dht.dat /aria2/conf/dht.dat
fi
if [ ! -f /aria2/conf/on-complete.sh ]; then
	cp /aria2/conf-temp/on-complete.sh /aria2/conf/on-complete.sh
fi

# override default time zone (Etc/UTC) if TZ variable is set. Beijing time: Asia/Shanghai
if [ $TZ ]; then
  cp /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
  date
  echo "Update timezone to ${TZ}"
fi

chmod +x /aria2/conf/on-complete.sh
touch /aria2/conf/aria2.session

darkhttpd /aria-ng --port 80 &
darkhttpd /aria2/downloads --port 8080 &
aria2c --conf-path=/aria2/conf/aria2.conf &
# start crontab, auto update bt tracker at 8am daily
exec crond -l 5 -f "$@"
