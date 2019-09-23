#!/usr/bin/env bash

FILE_NAME="eth0.pcap"
FILTER=""
SCRIPT_NAME=$0

usage() {
	echo "${SCRIPT_NAME}"
	echo "[ -i | -input_pcap <pcap file> | default=${FILE_NAME}"
	echo "[ -f | -input_filter <filter> | default=\"\" ]"
	echo "[ -h | --help ]"
}

while [ "$1" != "" ]; do
	case $1 in
		-i | --input_pcap )
			shift
			FILE_NAME=$1
			;;
		-f | -input_filter )
			shift
			FILTER=$1
			;;
		-h | --help )
			usage
			exit 0
			;;
		* )
			usage
			exit 1;
	esac
	shift
done
ACCU=""	
while read line; do
	if [[ $line =~ length ]]; then
		echo $ACCU
		ACCU=$(echo $line | cut -d'.' -f1)":"
	else
		ACCU=${ACCU}$(echo $line | cut -d: -f2- | tr -s ' '| sed -e 's/ //g')
	fi
done < <(tcpdump -r ${FILE_NAME} -xx ${FILTER} | tr -s ' ' )
