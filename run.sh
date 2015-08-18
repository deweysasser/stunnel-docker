#!/bin/bash

set -e 
set -u

# Purpose:  propigate environment variables into the config

# First update the configuration files
cp /etc/stunnel.dist/*.conf /etc/stunnel/
perl -i -p -e 's/ENV_(\w+)/$ENV{$1}/g' /etc/stunnel/*.conf

# Generate the keys if they're missing

if [ ! -f $KEYFILE ] ; then
    openssl genrsa -out $KEYFILE
fi

if [ ! -f $CRTFILE ] ; then
    CSRFILE="`dirname $CRTFILE`/`basename $CRTFILE .crt1`.csr"
    openssl req -new -key /etc/stunnel/server.pem -subj "/CN=$CERTNAME" -out $CSRFILE
    openssl x509 -req -days 365 -in $CSRFILE -out $CRTFILE -signkey $KEYFILE
fi

#chmod -R og-rwx /etc/stunnel
    
# Now run the commands given (which is stunnel by default)
eval "$@"