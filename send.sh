#!/bin/bash

# sms sending script by william (c) 2012

# password and user for the gateway
# ~~~~~ CONFIG BEGIN ~~~~~ #
LOGIN=XXXXX
PASSWD=XXXXX
# ~~~~~  CONFIG END  ~~~~~ #
# Do not edit anything below this line! #

# grab text, dest number and sending application
NUMBER="$1"; shift
SENDER="$2"; shift
TEXT="$*"

#### dest number input validation and fixes ####
# various number fixes
# change + in number to 00 if it exists
NUMBER=$(echo $NUMBER | sed -e "s/+/00/")

# number is fully numeric now, check this
if echo $NUMBER | grep "^[0-9]*$" >/dev/null
then
	echo "number numeric - ok" >> /dev/null
else
	echo "number not numeric - please fix"
	exit 1
fi

# change 00 in number to needed format for GET request (replace 00 with %2B (+))
NUMBER=$(echo $NUMBER | sed -e "s/00/%2B/")

#### /dest number input validation ####

#### sendername validation and fixes ####
# check if string is number or text
if echo $SENDER | grep "^[0-9]*$" >/dev/null
then
	#string is text, allow 11 characters
	SENDER=$(echo $SENDER | cut -c1-11)
else
	#string is number, allow 16 numbers
	SENDER=$(echo $SENDER | cut -c1-16)
fi

# replace empty strings with 0s
SENDER=$(echo $SENDER | sed -e "s/ /0/")

#### /sendername validation and fixes ####

#### text validation and fixes ####
# cut the text down to 150 chars max
TEXT=$(echo $TEXT | cut -c1-150)
# replace space with +
TEXT=$(echo $TEXT | sed -e "s/ /+/g")
#### /text validation and fixes ####
# checks completed, curl the gateway and send the SMS

curl -s "http://www.http2sms.com/sms/?id=$LOGIN&pw=$PASSWD&dnr=$NUMBER&snr=$SENDER&msg=$TEXT"