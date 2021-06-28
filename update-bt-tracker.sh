#!/bin/sh

# get url_list
url_list=`wget -qO- https://raw.githubusercontent.com/ngosang/trackerslist/master/trackers_best.txt|awk NF|sed ":a;N;s/\n/,/g;ta"`

# save to conf file
if [ `grep -c "bt-tracker" /aria2/conf/aria2.conf` -eq '0' ]; then
	sed -i '$a bt-tracker='${url_list} /aria2/conf/aria2.conf
else
    sed -i "s@bt-tracker.*@bt-tracker=$url_list@g" /aria2/conf/aria2.conf
fi

echo "bt-tracker updated to ${url_list}"

# Restart aria2 to make config work
# killall aria2c &>/dev/null
# sleep 3
# aria2c --conf-path=/aria2/conf/aria2.conf