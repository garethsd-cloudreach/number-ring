#!/bin/bash
# Opening number.txt, assuming it is in the same folder as the script, and incrementing the number in it
value=`cat number.txt`
new_value=`expr $value + 1`
echo $new_value > number.txt
# Copying the file to the next server
scp -i number-ring-key.pem /home/ec2-user/number.txt ec2-user@192.168.22.177:/home/users/ec2-user/

#Cronjob code: 43 15 25 11 4 /home/ec2-user/script.sh