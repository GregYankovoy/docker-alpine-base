FROM alpine:3.8

RUN apk add --update --no-cache \
    shadow \
    su-exec

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

VOLUME /config

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
