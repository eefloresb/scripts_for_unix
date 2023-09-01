echo "sftp start" >> test/logfile.log

sftp -b - gmdadmin@10.100.13.61 <<EOF 2>&1 | tee test/logfile.log
cd tgtfiles
lcd /home/gmdadmin/ansible/
rm *.csv
put -p *.csv
exit
EOF

exit_code=${PIPESTATUS[0]}

if [[ $exit_code != 0 ]]; then
echo "sftp error" >&2
exit 1
fi 

echo "sftp end" >> /test/logfile.log
