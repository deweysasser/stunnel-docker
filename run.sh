#!/bin/bash

set -e 
set -u

# Purpose:  propigate environment variables into the config

# First update the configuration files
perl -i -p -e 's/ENV_(\w+)/$ENV{$1}/g' /etc/stunnel/*.conf

# Generate the keys if they're missing

if [ ! -f /etc/stunnel/server.pem ] ; then
    openssl genrsa -out /etc/stunnel/server.pem
fi

if [ ! -f /etc/stunnel/server.crt ] ; then
    openssl req -new -key /etc/stunnel/server.pem -subj "/CN=$CERTNAME" -out /etc/stunnel/server.csr
    openssl x509 -req -days 365 -in /etc/stunnel/server.csr -out /etc/stunnel/server.crt -signkey /etc/stunnel/server.pem
fi

#chmod -R og-rwx /etc/stunnel
    
# Now run the commands given (which is stunnel by default)
eval "$@"