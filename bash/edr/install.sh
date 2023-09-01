#!/bin/bash
PKGINSTALL="Agent-Core-AIX-20.0.0-1540.powerpc.bff.gz"
while read line; do
if ! ssh psgmdspc@$line ls -ld /tmp/$PKGINSTALL 2>&1 1>/dev/null; then
	scp $PKGINSTALL @$line:/tmp/
fi
ssh psgmdspc@$line "bash -s" < main.sh
done < servers.txt
