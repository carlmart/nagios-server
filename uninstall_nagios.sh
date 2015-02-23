#!/bin/sh

## UNINSTALL NOTICE #########################################
fmt -s -w $(tput cols) <<-EOF
        ==================================
        !! DESTRUCTIVE UNINSTALL NOTICE !!
        ==================================
        WARNING: This script will uninstall Nagios, keep MYSQL and Postgresql
        
        Nagios 
        
        from this system as well as all data associated with these services.
        This action is irreversible and will result in the removal of

EOF

read -p "Are you sure you want to continue? [y/N] " res

if [ "$res" = "y" -o "$res" = "Y" ]; then
        echo "Proceeding with uninstall..."
else
        echo "Uninstall cancelled"
        exit 1
fi

# Stop services
echo "Stopping services..."
service nagios stop

# Remove init.d files
echo "removing init files... : /etc/init.d/nagios "
rm -rf /etc/init.d/nagios

# Remove users and sudoers
echo "Removing users and suduoers... : nagios/nagcmd "
userdel -r nagios
groupdel nagcmd

# Remove nagios  root files
echo "Removing nagios server root  files... /usr/local/nagios "
rm -rf /usr/local/nagios

service apache2 restart



