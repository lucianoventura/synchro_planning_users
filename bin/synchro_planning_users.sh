#!/bin/bash
script_version="2.0.0"

# Created by:  luciano.ventura@gmail.com in 2014-05-08



echo
echo
echo



show_usage(){                   # HAU-TU use the syncro planning users
     
    echo
    echo
    echo "HAU-TU use the syncro planning users"
    echo
    echo "$(basename $0) /u01/Oracle/home_infra/synchro_planning_users/conf/syncro_planning_users.conf"
    echo
    echo
}
#
##############################################################################
#



readonly SUCCESS=0                              # generic success
readonly FAILURE=1                              # generic error



# check if missing file.conf as first parameter  
if [ -z "$1" ]; then
     
    show_usage
     
	exit $FAILURE
fi



############
conf_file=$1
############



#    
##############################################################################
#
check_file(){                   # check if any external file is OK to be read
     
    file_to_check="$1"
     
     
    if [ ! -e "$file_to_check" ]; then
         
        echo "[$(date +%T)] [ERROR] $file_to_check is NOT there"            | tee -a $err_log_file 
        echo ""                                                             | tee -a $err_log_file
        return $FAILURE
    fi
     
     
    if [ ! -f "$file_to_check" ]; then          # file is not a file :-)
         
        echo "[$(date +%T)] [ERROR] $file_to_check is NOT a file"           | tee -a $err_log_file
        echo ""                                                             | tee -a $err_log_file
        return $FAILURE
    fi        
     
     
    if [ ! -s "$file_to_check" ]; then          # File is not zero byte
         
        echo "[$(date +%T)] [ERROR] $file_to_check is EMPTY"                | tee -a $err_log_file
        echo ""                                                             | tee -a $err_log_file
        return $FAILURE
    fi
     
     
    if [ ! -r "$file_to_check" ]; then          # File can be read
         
        echo "[$(date +%T)] [ERROR] $file_to_check is NOT readable"         | tee -a $err_log_file
        echo ""                                                             | tee -a $err_log_file
        return $FAILURE
    fi
     
     
    echo "[$(date +%T)] [INFO] $file_to_check is OK reading it"             | tee -a $out_log_file
    echo ""                                                                 | tee -a $out_log_file
     
    return $SUCCESS
}
#    
##############################################################################
#



# read conf file if OK 
if check_file $conf_file; then
     
    source $conf_file
else
    show_usage
     
    exit $FAILURE
fi



echo                                                                                        | tee -a $out_log_file $err_log_file
echo                                                                                        | tee -a $out_log_file $err_log_file
echo                                                                                        | tee -a $out_log_file $err_log_file
echo "[$(date +%T)] [INFO] #####################################################"           | tee -a $out_log_file $err_log_file
echo "[$(date +%T)] [INFO] ###   Starting...           version: $script_version "           | tee -a $out_log_file $err_log_file
echo "[$(date +%T)] [INFO] #####################################################"           | tee -a $out_log_file $err_log_file
echo                                                                                        | tee -a $out_log_file $err_log_file
echo                                                                                        | tee -a $out_log_file $err_log_file
echo                                                                                        | tee -a $out_log_file $err_log_file



# check if all files are OK
for file_to_check in $password_file $update_command $provis_command; do
     
    if ! check_file $file_to_check; then
         
        echo "[$(date +%T)] [ERROR] Exiting with error"                                     | tee -a $out_log_file $err_log_file
        echo                                                                                | tee -a $out_log_file $err_log_file
        echo "[$(date +%T)] [ERROR] #####################################################"  | tee -a $out_log_file $err_log_file
        echo                                                                                | tee -a $out_log_file $err_log_file
         
        exit $FAILURE
    fi
done



echo "[$(date +%T)] [INFO] #####################################################"           | tee -a $out_log_file
echo "[$(date +%T)] [INFO] ###   Running >> Update <<  for  >> $app_name <<     "           | tee -a $out_log_file
echo "[$(date +%T)] [INFO] #####################################################"           | tee -a $out_log_file
echo                                                                                        | tee -a $out_log_file
echo                                                                                        | tee -a $out_log_file
echo                                                                                        | tee -a $out_log_file

$update_command -f:$password_file $host_name $admin_user $app_name  1>> $out_log_file 2>> $err_log_file

echo                                                                                        | tee -a $out_log_file
echo                                                                                        | tee -a $out_log_file
echo                                                                                        | tee -a $out_log_file
echo "[$(date +%T)] [INFO] #####################################################"           | tee -a $out_log_file
echo "[$(date +%T)] [INFO] ### Running >> Provision <<  for  >> $app_name <<    "           | tee -a $out_log_file
echo "[$(date +%T)] [INFO] #####################################################"           | tee -a $out_log_file
echo                                                                                        | tee -a $out_log_file
echo                                                                                        | tee -a $out_log_file
echo                                                                                        | tee -a $out_log_file

$provis_command -f:$password_file /ADMIN:$admin_user /A:$app_name   1>> $out_log_file 2>> $err_log_file

echo                                                                                        | tee -a $out_log_file
echo                                                                                        | tee -a $out_log_file
echo                                                                                        | tee -a $out_log_file
echo "[$(date +%T)] [INFO] output log for details:"
echo                                                                                        | tee -a $out_log_file
echo                                                                                        | tee -a $out_log_file
echo                                                                                        | tee -a $out_log_file
echo "$out_log_file"
echo
echo
echo
echo "[$(date +%T)] [INFO] Exiting script..."                                               | tee -a $out_log_file $err_log_file
echo                                                                                        | tee -a $out_log_file $err_log_file
echo "############################################################"                         | tee -a $out_log_file $err_log_file
