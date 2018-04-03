#!/bin/bash
#
# Dynamic IP host update for GoDaddy hosted domain
# by Irek 'Monsoft' Pelech
# Ascot, Easter 2018

# Script require 'jq' to be installed.
# Look to jq website https://stedolan.github.io/jq


# Check if 'jq' is installed
command -v jq >/dev/null 2>&1 || { echo "jq is not installed. Exiting." >&2; exit 1; }

# API login
KEY='GoDaddy API KEY'
SECRET='GoDaddy API Secret'

DOMAIN="example.com"		# Domain
HOST="www"					# Host
HCVALUE=$(curl -s -X GET -H "Authorization: sso-key $KEY:$SECRET" https://api.godaddy.com/v1/domains/$DOMAIN/records/A/$HOST | jq ".[]|.data"|sed 's/"//g')		# Check currently setup IP in DNS
CIP=$(curl -s http://checkip.amazonaws.com)		# Grab your current external IP

# Test if returned values are IP addresses
if [[ ! ( "${HCVALUE}" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ) || ! ( "${CIP}" =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ) ]]; then
	echo "DNS record check or your current IP check returned not IP value !!!"
	exit 1
fi


# Compare IPs and update DNS record
if [ ! "${CIP}" = "${HCVALUE}" ];then
	HTTP_CODE=$(curl -sw '%{http_code}' -X PUT -d "{\"data\": \"$CIP\",\"ttl\": 600}" -H "Authorization: sso-key $KEY:$SECRET" -H "Content-Type: application/json" https://api.godaddy.com/v1/domains/$DOMAIN/records/A/$HOST -o /dev/null)
	if [ "${HTTP_CODE}" = "200" ]; then
		echo "DNS record $HOST.$DOMAIN updated to $CIP"
	else
		echo "Something went wrong !!! HTTP Code: ${HTTP_CODE}"
	fi
fi
