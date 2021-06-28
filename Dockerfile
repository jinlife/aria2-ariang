FROM alpine:edge

MAINTAINER jinlife <glucose1e@tom.com>

#ENV ARIANG_VERSION=1.1.1

RUN apk update \
	&& apk add --no-cache --update aria2 darkhttpd tzdata \
	&& mkdir -p aria2/conf aria2/conf-temp aria2/downloads aria-ng \
	&& ARIANG_VERSION=$(wget --no-check-certificate -qO- https://api.github.com/repos/mayswind/AriaNg/releases/latest | grep -o '"tag_name": ".*"' | sed 's/"//g;s/tag_name: //g') && echo ${ARIANG_VERSION} \
	&& wget --no-check-certificate https://github.com/mayswind/AriaNg/releases/download/${ARIANG_VERSION}/AriaNg-${ARIANG_VERSION}.zip \
	&& unzip AriaNg-${ARIANG_VERSION}.zip -d aria-ng \
	&& rm -rf AriaNg-${ARIANG_VERSION}.zip 

COPY init.sh /aria2/init.sh
COPY conf-temp /aria2/conf-temp

# Copy scripts
COPY update-bt-tracker.sh /
COPY crontab /var/spool/cron/crontabs/root

# Give execution rights on the cron job
RUN chmod 0644 /var/spool/cron/crontabs/root
RUN chmod +x /update-bt-tracker.sh
RUN chmod +x /aria2/init.sh

WORKDIR /
VOLUME ["/aria2/conf", "/aria2/downloads"]
EXPOSE 6800 80 8080

CMD ["/aria2/init.sh"]
