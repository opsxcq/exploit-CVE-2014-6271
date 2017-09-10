FROM debian:wheezy

LABEL maintainer "opsxcq@strm.sh"

RUN apt-get update && \
    apt-get upgrade -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apache2 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

COPY packages /packages

RUN dpkg -i /packages/*

COPY vulnerable /usr/lib/cgi-bin/
COPY index.html /var/www

RUN chown www-data:www-data /var/www/index.html

EXPOSE 80

COPY main.sh /

ENTRYPOINT ["/main.sh"]
CMD ["default"]

