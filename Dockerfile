FROM ubuntu:trusty
MAINTAINER Dewey Sasser <dewey@sasser.com>

RUN apt-get update
RUN apt-get -y install stunnel

RUN useradd -m stunnel

RUN mkdir -p /etc/stunnel /etc/stunnel.dist /ssl
COPY stunnel.conf /etc/stunnel.dist/stunnel.conf

EXPOSE 2000
ENV ACCEPT 2000

RUN chown stunnel /etc/stunnel

VOLUME /etc/stunnel

ENV CERTNAME stunnel
ENV KEYFILE /etc/stunnel/server.pem
ENV CRTFILE /etc/stunnel/server.crt

RUN chown stunnel /var/run/stunnel4 /etc/stunnel

COPY run.sh /run.sh
RUN chmod +x /run.sh

USER stunnel
CMD ["stunnel4 /etc/stunnel/stunnel.conf"]
ENTRYPOINT ["/run.sh"]

