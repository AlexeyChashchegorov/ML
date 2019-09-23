#!/usr/bin/env bash

IFACE_NAME="eth0"
OUT_FILE="${IFACE_NAME}.pcap"
TIME_SECONDS=10

SCRIPT_NAME=$0

usage() {
	echo "${SCRIPT_NAME}"
	echo "[ -i | --interface <interface_name> | default=${IFACE_NAME} ] "
	echo "[ -o | --out_file <file_name> | default=${OUT_FILE} ] "
	echo "[ -t | --time_seconds <capture time> | default=${TIME_SECONDS} ] "
	echo "[ -h | --help ] "
}

while [ "$1" != "" ]; do
	case $1 in
		-i | --interface )
			shift
			IFACE_NAME=$1
			OUT_FILE=${IFACE_NAME}.pcap
			;;
		-o | --out_file )
			shift
			OUT_FILE=$1
			;;
		-t | --time_seconds )
			shift
			TIME_SECONDS=$1
			;;
		-h | --help )
			usage
			exit 0
			;;
		* )
			usage
			exit 1
	esac
	shift
done

CMD="tcpdump -i ${IFACE_NAME} -w ${OUT_FILE} & sleep ${TIME_SECONDS} ;pkill tcpdump"
tcpdump -i ${IFACE_NAME} -w ${OUT_FILE} > /dev/null 2>&1 & sleep ${TIME_SECONDS} ; pkill tcpdump > /dev/null 2>&1
if [ $? -ne 0 ]; then
	echo execution failed: ${CMD} 
	exit 1
fi 
