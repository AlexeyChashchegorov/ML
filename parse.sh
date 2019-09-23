#!/usr/bin/env bash

FILE_NAME="eth0.pcap"
SCRIPT_NAME=$0

usage() {
	echo "${SCRIPT_NAME} [ -i | -input_pcap <pcap file> | default=${FILE_NAME}"
	echo "           [ -h | --help ]"
}

while [ "$1" != "" ]; do
	case $1 in
		-i | --input_pcap )
			shift
			FILE_NAME=$1
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
	#echo $line
	if [[ $line =~ length ]]; then
		echo $ACCU
		ACCU=$(echo $line | cut -d'.' -f1)":"
	else
		ACCU=${ACCU}$(echo $line | cut -d: -f2- | tr -s ' '| sed -e 's/ //g')
	fi
done < <(tcpdump -r ${FILE_NAME} -xx | tr -s ' ' )
