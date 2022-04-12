#!/bin/bash

OLD_IFS=$IFS
IFS=','
FQDN=$1
DIR=$(pwd)
KEYLINE="----------KEY----------"
CSRLINE="----------CSR----------"
COUNTRY="NO"
STATE="Oslo"
LOCALITYNAME="Oslo"
ORGANIZATION="Contoso"

usage() {
	echo 'Syntax: CreateSSL.sh <FQDN> [[ -d ][ --directory ] <directory>] [[ -s ][ --subdomain ] <domain1,domain2>] [[ -C ][ --country ] <country>] [[ -S ][ --state ] <state>] [[ -L ][ --localityname ] <localityname>] [[ -O ][ --organization ] <organization>]'
	exit 1
}

opensslConfig() {
	touch $DIR/${FQDN}.conf
	echo "[req]" > $DIR/${FQDN}.conf
	echo "distinguished_name = req_distinguished_name" >> $DIR/${FQDN}.conf
	echo "req_extensions = v3_req" >> $DIR/${FQDN}.conf
	echo "prompt = no" >> $DIR/${FQDN}.conf
	echo "[req_distinguished_name]" >> $DIR/${FQDN}.conf
	echo "C = $COUNTRY" >> $DIR/${FQDN}.conf
	echo "ST = $STATE" >> $DIR/${FQDN}.conf
	echo "L = $LOCALITYNAME" >> $DIR/${FQDN}.conf
	echo "O = $ORGANIZATION" >> $DIR/${FQDN}.conf
	echo "CN = $FQDN" >> $DIR/${FQDN}.conf
	echo "[v3_req]" >> $DIR/${FQDN}.conf
	echo "keyUsage = keyEncipherment, dataEncipherment" >> $DIR/${FQDN}.conf
	echo "extendedKeyUsage = serverAuth" >> $DIR/${FQDN}.conf
	echo "subjectAltName = @alt_names" >> $DIR/${FQDN}.conf
	echo "[alt_names]" >> $DIR/${FQDN}.conf
}

createSubdomains() {
	opensslConfig
	COUNT=1
	for i in $DNS; do
		echo "DNS.$COUNT = $i" >> $DIR/${FQDN}.conf
		((COUNT++))
	done
	openssl req -new -out $DIR/$FQDN.csr -newkey rsa:2048 -nodes -sha256 -keyout $DIR/$FQDN.temp.key -config $DIR/$FQDN.conf && openssl rsa -aes256 -passout pass:$KEYPASS -in $DIR/$FQDN.temp.key -out $DIR/$FQDN.key && rm $DIR/$FQDN.temp.key
	echo
	echo $CSRLINE
	openssl req -text -noout -verify -in  $DIR/$FQDN.csr
	echo
	echo $KEYLINE
	cat  $DIR/$FQDN.key
  rm $DIR/$FQDN.conf
}

if [ -z $FQDN ]; then
	usage
else
	shift 1
fi

printf "Enter PEM pass phrase: " && read -s KEYPASS

PARSED_ARGUMENTS=$(getopt -a -n CreateSSL -o d:C:S:L:O:s:d:h --longoptions directory:,country:,state:,localityname:,organization:,subdomain:,help -- "$@")

# Define list of arguments expected in the input
while :
do
	case $1 in
		-d | --directory) DIR="$2" ; shift 2 ;;
		-C | --country) COUNTRY="$2" ; shift 2 ;;
		-S | --state) STATE="$2" ; shift 2 ;;
		-L | --localityname) LOCALITYNAME="$2" ; shift 2 ;;
		-O | --organization) ORGANIZATION="$2" ; shift 2 ;;
		-s | --subdomain) DNS="$2" ; createSubdomains ; shift 2 ;;
		-h | --help) usage ; shift 1 ;;
		*) break ;;
	esac
done

if [ -z "$DNS" ]; then
	openssl req -new -newkey rsa:2048 -nodes -keyout $DIR/$FQDN.temp.key -out $DIR/$FQDN.csr -subj "/C=$COUNTRY/ST=$STATE/L=$LOCALITYNAME/O=$ORGANIZATION/CN=$FQDN" && openssl rsa -aes256 -passout pass:$KEYPASS -in $DIR/$FQDN.temp.key -out $DIR/$FQDN.key && rm $DIR/$FQDN.temp.key
	echo
	echo $CSRLINE
	openssl req -text -noout -verify -in  $DIR/$FQDN.csr
	echo
	echo $KEYLINE
	cat  $DIR/$FQDN.key
fi
IFS=$OLD_IFS
