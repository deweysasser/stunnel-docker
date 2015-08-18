stunnel-docker
==============

A docker image for running an SSL terminating proxy to an arbitrary service.

Usage
-----

To secure IMAP:

     docker run -it -p 993:2000 -e CONNECT=mail:143 --cap-drop ALL deweysasser/stunnel

To secure a web server:
        docker run -it -p 443:2000 -e CONNECT=web:143 -link web:web --cap-drop ALL deweysasser/stunnel

Usage Notes
-----------

* The default binding port is 2000, so you can run with -cap-drop all
  (which is a good idea).  You can change this port, but there's no
  reason to and it will prevent you from using the cap-drop.

* Run one of these per service you're wrapping (docker-compose is excellent!)

Certificates
------------

You can map in the volume /etc/stunnel containing server.pem and
server.crt, respectively the SSL server key and certificate.  If you
do not give it one, a self-signed certificate will be created
automatically.

If you don't want a self-signed certificate, you can use the created
/etc/stunnel/stunnel.csr to request a certificate from an appropriate
authority.

To properly create the file, concatenate the entire certificate chain
give by the CA into "server.crt", in order starting with the host
certificate and ending with the CA Root certificate.