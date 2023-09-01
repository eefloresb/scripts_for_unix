#!/usr/bin/bash
_x_user_cron()
{
  command=$(crontab -l $1 2>&1)
  if [ $(echo $?) -eq "0" ]; then
      echo "The user $1 have configured the cron"
  fi
}

for i in $(cat /etc/passwd | awk -F ":" '{print $1}'); do
  _x_user_cron $i
done