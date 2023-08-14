while true
 do
   python manage.py migrate
   if [ $? -ne 0 ]
     then
     echo "DB needs more time"
     sleep 5
     continue
   else
     echo "Done migration"
     break
   fi
 done 
