#!/bin/sh
NG="nagios-4.0.8.tar.gz"
PG="nagios-plugins-2.0.3.tar.gz"
#
#

sudo apt-get install tasksel build-essential libgd2-xpm-dev apache2-utils -y
echo
echo "latest releases $NG"
echo "latest releases $PG"
echo "open up another window to complete install.."
echo "install lamp server by running:   sudo tasksel"
echo "and add LAMP server - press any key to continue"
read X

echo "creating new user nagios"
sudo useradd -m nagios
echo "change password for nagios user"
sudo passwd nagios
sudo groupadd nagcmd
sudo usermod -a -G nagcmd nagios
sudo usermod -a -G nagcmd www-data
echo
echo "Download nagios latest release"
echo "http://www.nagios.org/download/"
DT=`date`
echo $DT
wget http://prdownloads.sourceforge.net/sourceforge/nagios/$NG
echo "download plugins"
wget http://nagios-plugins.org/download/$PG


echo "tar zxvf files and cd folder / ./configure , then sudo make all, sudo make install"
tar zxf $PG
tar zxf $NG

N=`echo $NG | sed 's/.tgz//'`
P=`echo $PG | sed 's/.tgz//'`

echo "Compile and build nagios  $N "
( cd $N ; sudo ./configure --with-command-group=nagcmd )
( cd $N ; sudo make all )
( cd $N ; sudo make install )
( cd $N ; sudo make install-init )
( cd $N ; sudo make install-config )
( cd $N ; sudo make install-commandmode )

echo "Ubuntu only :"
( cd $N ; sudo /usr/bin/install -c -m 644 sample-config/httpd.conf /etc/apache2/sites-enabled/nagios.conf )

#echo "Other distros you want to install under /usr/httpd/conf.d/nagios.conf "
#( cd $N ; sudo make install-webconf ) # defaults to /usr/httpd/conf.d/nagios.conf

echo "create a web interface userid nagiosadmin AND remember password you entered ;) "
sudo htpasswd -c /usr/local/nagios/etc/htpasswd.users nagiosadmin

echo "restart apache2 (ubuntu)"
sudo service apache2 restart

echo "Compile and build plugins  $P"
( cd $P ; sudo ./configure --with-nagios-user=nagios --with-nagios-group=nagios )
( cd $P ; sudo make all)
( cd $P ; sudo make install )

echo "Nagios sample configuration files are located under /usr/local/nagios/etc directory"
echo 
echo "Edit your local file contacts.cfg by adding your contact info"
echo "and sudo copy to /usr/local/nagios/etc/" 

echo "sudo vi /usr/local/nagios/etc/objects/contacts.cfg"

echo "Edit your local file nagios.conf "
echo "and sudo copy to /etc/apache2/sites-enabled/"
echo "SSLRequireSSL  # uncomment SSL (I did for security reasons"
echo "Order deny,allow"
echo "Deny from all"
echo "Allow from 127.0.0.1 192.168.1.0/24"
echo
echo "enable apache rewrite and cgi modules"
sudo a2enmod rewrite
sudo a2enmod cgi

echo "sudo service apache2 restart"
echo "check to make sure you have no errors"

sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg


echo "if it works , soft link to startup files"
echo "sudo ln -s /etc/init.d/nagios /etc/rcS.d/S99nagios"







