#!/bin/bash
__usage()
{
    if [ -n "$1" ] ; then
        echo "$1" >&2
        echo ""
    fi
cat << EOT >&2
  Daemon Apache start
  Usage: ./$0 -h
  Daemon Nginx start 
  Usage: ./$0 -n
  All daemon start
  Usage: ./$0 -a
EOT
exit 1
}

__startd_httpd(){

  if [[ $(ps -fea|grep httpd|grep -v grep  | wc -l) = 0 ]]; then
    echo "the httpd service is stopped"
    echo "execute command start httpd"
    echo "ejecutando.... systemctl start httpd"
    systemctl statrt httpd  
  else
    process=$(ps -fea|grep httpd|grep -v grep | awk -F "[V ]+" '{print $2}' | xargs)
    echo "the httpd is run current in $process"
  fi
}

__startd_nginx(){
  if [[ $(ps -fea|grep nginx|grep -v grep  | wc -l) = 0 ]]; then
    echo "the nginx service is stopped"
    echo "execute command start nginx"
    echo "ejecutando ... systemctl start nginx"
    systemctl statrt nginx
  else
    process=$(ps -fea|grep nginx|grep -v grep | awk -F "[V ]+" '{print $2}' | xargs)
    echo "the nginx is run current in $process"
  fi
}

while getopts 'a,h,s' OPTS; do
  case '$OPTS' in
    -t) __startd_httpd;;
    -n) __startd_nginx;;
    -a) 
        __startd_nginx 
        __startd_httpd
        ;;
     *) __usage;;
  esac
done


if [ -z "$1" ]; then 
    echo "you must enter at least one parameter"
    echo "$0 -h ==> start and status httpd"
    echo "$0 -n ==> start and status nginx"
    echo "$0 -a ==> both services"
    exit
fi
