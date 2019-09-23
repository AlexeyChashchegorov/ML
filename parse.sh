#!/usr/bin/env bash

FILE_NAME="eth0.pcap"
FILTER=""
SHOW_OPTION=""
START=0
FINISH=0
SCRIPT_NAME=$0

usage() {
	echo "${SCRIPT_NAME}"
	echo "[ -i | --input_pcap <pcap file> | default=${FILE_NAME}"
	echo "[ -f | --input_filter <filter> | default=\"\" ]"
	echo "[ --show_interval <start index, finish index> ] mutual"
	echo "[ --show_ip_version ] mutual"
	echo "[ --show_header_len ] mutual"
	echo "[ --show_dscp_ecn ] mutual" #TODO separate fields
	echo "[ --show_total_lenght ] mutual"
	echo "[ --show_identification ] mutual"
	echo "[ -h | --help ]"
}

while [ "$1" != "" ]; do
	case $1 in
		-i | --input_pcap )
			shift
			FILE_NAME=$1
			;;
		-f | --input_filter )
			shift
			FILTER=$1
			;;
		--show_interval )
			shift
			START=$1
			shift
			FINISH=$1
			;;
		--show_ip_version )
			START=29
			FINISH=29
			;;
		--show_header_len )
			START=30
			FINISH=30
			;;
		--show_dscp_ecn )
			START=31
			FINISH=32
			;;
		--show_total_length )
			START=33
			FINISH=36
			;;
		--show_identification )
			START=37
			FINISH=40
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
TIME=""
echo $START $FINISH
while read line; do
	if [[ $line =~ length ]]; then
		DATA=${ACCU}
		if [ "$START" -ne "0" ] || [ "$FINISH" -ne "0" ]; then
			DATA=$(echo ${ACCU} | cut -c${START}-${FINISH})	
		fi
		echo ${TIME}${DATA}
		TIME=$(echo $line | cut -d'.' -f1)":"
		ACCU=""
	else
		ACCU=${ACCU}$(echo $line | cut -d: -f2- | tr -s ' '| sed -e 's/ //g')
	fi
done < <(tcpdump -r ${FILE_NAME} -xx ${FILTER} | tr -s ' ' )
