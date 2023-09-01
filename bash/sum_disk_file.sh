#!/bin/bash
declare -i sum=0
lsblk | grep disk|awk '{print $4}'|while read line; do
 declare -i linex=$(echo $line | tr -d "G")
sum=$((sum+linex))
done
echo $sum
