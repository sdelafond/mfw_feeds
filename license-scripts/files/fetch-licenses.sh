#!/bin/sh

usage() {
    echo "Usage: $0 <options>"
    echo "Options: "
    exit 1;
}

for f in /etc/os-release /tmp/sysinfo/board_name /etc/config/uid ; do
    if [ ! -f $f ] ; then
        echo "Missing $f file"
        exit 1
    fi
done

source /etc/os-release
source /usr/share/libubox/jshn.sh

DEVICE="`cat /tmp/sysinfo/board_name | tr -d '[ \t\r\n]'`"
UID="`cat /etc/config/uid | tr -d '[ \t\r\n]'`"

ARGS="version=${VERSION}&device=${BOARD}&uid=${UID}"
URL="https://license.untangle.com/license.php?action=getLicenses&${ARGS}"
OUTPUT="/tmp/licenses.json"
SIMULATE=0
FILE="/etc/config/licenses.json"

echo "Downloading licenses... "
rm -f $OUTPUT

wget -t 5 --timeout=30 -q -O $OUTPUT $URL
if [ $? != 0 ] ; then
    echo "Failed to download licenses ($?)."
    exit 1
else
    echo "Saving licenses in $FILE"
    cp $OUTPUT $FILE
fi





