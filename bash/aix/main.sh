#!/bin/bash
SERVIDORES="10.10.31.66 10.10.31.67 10.10.31.118 10.10.31.119"
for i in $SERVIDORES; do
  echo $i
  ssh psgmdspc@$i 'bash -s' < check-size-space.sh > /tmp/$i.csv
  echo "#################" 
done
