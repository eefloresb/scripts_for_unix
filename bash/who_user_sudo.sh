OS=$(uname)
          rm /tmp/users.txt /tmp/plantilla.txt 
    if [ "$OS" == "Linux" ]; then              
         __get_user_sudo(){
             cat /etc/passwd|awk -F ":" '{print $1}' | while read line; do  sudo -l -U $line; done | grep -B1 -E "(ALL$)" > /tmp/log_tmp_user.txt
         }

        __get_user_root(){
            cat /tmp/log_tmp_user.txt | grep -i user |awk '{print $2}' | while read line; do 
                echo "$line" >> /tmp/users.txt 
            done
          while read line; do
           comment=$(grep -E ^$line /etc/passwd | awk -F ":" '{print $5}')
           user=$line
           echo -n $user,$comment: >> /tmp/plantilla.txt 
          done</tmp/users.txt 
        }
        __get_user_sudo
        __get_user_root
        sed -rie "s/:$//g" /tmp/plantilla.txt 
        cat /tmp/plantilla.txt 
        elif [ "$OS" == "AIX" ]; then
             cat /etc/passwd|awk -F ":" '{print $1}' | while read user; do  sudo -l -U $user; done | grep -E "(ALL$|may run|su - root)" >> /tmp/users.txt
             grep User /tmp/users.txt | awk 'print $2' > /tmp/users2.txt 
             mv /tmp/users2.txt /tmp/users.txt
             while read user; do 
                comment=$(grep $user /etc/passwd | awk -F ":" '{print $1":"$5}')
                user=$user 
                 echo -n $user,$comment: >> /tmp/plantilla.txt
             done</tmp/users.txt
             sed -rie "s/:$//g" /tmp/plantilla.txt 
        elif [ "$OS" == "HPUX" ]; then 
        fi