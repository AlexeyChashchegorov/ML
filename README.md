# Repository to extract specific data from captured traffic

Contains 2 scripts:
- capture.sh : capture traffic for specific interface in limited time
- extract.sh : extractor of specific binary data from *pcap file

Excecution:
./capture.sh -i "interface name" -o "output.pcap" -t "capture time"
./parse.sh -i "input.pcap" 
