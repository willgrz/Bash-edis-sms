#!/bin/bash

# sms sending script by william (c) 2012

# password and user for the gateway
# ~~~~~ CONFIG BEGIN ~~~~~ #
LOGIN=XXXXX
PASSWD=XXXXX
# ~~~~~  CONFIG END  ~~~~~ #
# Do not edit anything below this line! #

urlencode() {
	# Usage: urlencode "<string>"
	local length="${#1}"
	for (( i = 0; i < length; i++ )); do
		local c="${1:i:1}"
		case $c in
			[a-zA-Z0-9.~_-]) printf "$c" ;;
			*) printf '%%%02X' "'$c"
		esac
	done
}

NUMBER="$1"; shift
SENDER="$1"; shift
TEXT="$*"

NUMBER=$(echo "$NUMBER" | sed -r 's/^00/+/;s/[^0-9]//g');

if ! echo "$SENDER" | egrep -q '^[0-9]{1,11}$'; then
	if ! echo "$SENDER" | egrep -q '^.{1,16}$'; then
		echo "Invalid sender number or name"
		exit 1
	fi
fi

#######################################################################
# The maximum length of text message that you can send is 918         #
# characters. However, if you send more than 160 characters then your #
# message will be broken down in to chunks of 153 characters before   #
# being sent to the recipient's handset.                              #
#######################################################################

LOGIN=$(urlencode "$LOGIN")
PASSWD=$(urlencode "$PASSWD")
NUMBER=$(urlencode "$NUMBER")
SENDER=$(urlencode "$SENDER")

for seek in $(seq 0 918 "${#TEXT}"); do
	TEXTPART=$(urlencode "${TEXT:seek:918}")
	echo curl -s "http://www.http2sms.com/sms/?id=$LOGIN&pw=$PASSWD&dnr=$NUMBER&snr=$SENDER&msg=$TEXT"
done