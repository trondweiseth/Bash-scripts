#!/bin/bash

OLD_IFS=$IFS
IFS=','
FQDN=$1
DIR=$(pwd)
KEYLINE="----------KEY----------"
CSRLINE="----------CSR----------"

usage() {
	echo 'Syntax: CreateSSL.sh <FQDN> [ [-s]/[-subdomain] <DNS1,DNS2> ]'
	exit 1
}

opensslConfig() {
	touch $DIR/${FQDN}.conf
	echo "[req]" > $DIR/${FQDN}.conf
	echo "distinguished_name = req_distinguished_name" >> $DIR/${FQDN}.conf
	echo "req_extensions = v3_req" >> $DIR/${FQDN}.conf
	echo "prompt = no" >> $DIR/${FQDN}.conf
	echo "[req_distinguished_name]" >> $DIR/${FQDN}.conf
	echo "C = NO" >> $DIR/${FQDN}.conf
	echo "ST = Oslo" >> $DIR/${FQDN}.conf
	echo "L = Oslo" >> $DIR/${FQDN}.conf
	echo "O = Contoso" >> $DIR/${FQDN}.conf
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

PARSED_ARGUMENTS=$(getopt -a -n OpenSSLCert -o hs: --longoptions help,subdomain: -- "$@")

# Define list of arguments expected in the input
while :
do
	case $1 in
		-s | --subdomain) DNS="$2" ; createSubdomains ; shift 2 ;;
		-h | --help) usage ; shift ;;
		*) break ;;
	esac
done

if [ -z "$DNS" ]; then
	openssl req -new -newkey rsa:2048 -nodes -keyout $DIR/$FQDN.temp.key -out $DIR/$FQDN.csr -subj "/C=NO/ST=Oslo/L=Oslo/O=Contoso/CN=$FQDN" && openssl rsa -aes256 -passout pass:$KEYPASS -in $DIR/$FQDN.temp.key -out $DIR/$FQDN.key && rm $DIR/$FQDN.temp.key
	echo
	echo $CSRLINE
	openssl req -text -noout -verify -in  $DIR/$FQDN.csr
	echo
	echo $KEYLINE
	cat  $DIR/$FQDN.key
fi
IFS=$OLD_IFS
