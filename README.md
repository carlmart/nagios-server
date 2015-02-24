# nagios-server 
  build and install nagios server for Ubuntu 14.04 
  
  If you can't seem to figure out how to install [Nagios](http://www.nagios.com/legal/licenses/)
  for Ubuntu and you are really set in your ways....

  Yes there is no Ubuntu package , so I am slowly working on building a package repository.

  First , lets move it out of svn and host it on gitub.

 
### Server Build




### Server configuration
edit /usr/local/nagios/etc/nagios.cfg to identify the type of configuration file setup.

ex. # Specify individual object config files as shown below:
```
cfg_file=/usr/local/nagios/etc/objects/commands.cfg
cfg_file=/usr/local/nagios/etc/objects/contacts.cfg
cfg_file=/usr/local/nagios/etc/objects/timeperiods.cfg
cfg_file=/usr/local/nagios/etc/objects/templates.cfg
```

Also uncomment the following so you can add individual files under each directory
```
cfg_dir=/usr/local/nagios/etc/printers
cfg_dir=/usr/local/nagios/etc/servers
cfg_dir=/usr/local/nagios/etc/routers
```

Create groups of top level directories for your configuration files for easy management.

```
for i in objects printers servers routers
  do
     sudo mkdir -p /usr/local/nagios/etc/$i
  done
```

Edit object files beneath /usr/local/nagios/etc/  

ex. edit file commands.cfg to make sure you have the services you need, with the following command:
```
sudo vi /usr/local/nagios/etc/objects/commands.cfg 
define service {
        use                             generic-service
        host_name                       client
        service_description             SSH
        check_command                   check_ssh
        notifications_enabled           0
        }

define command {
        command_name    check_uptime
        command_line    $USER1$/check_uptime -H $HOSTADDRESS$ -w $ARG1$ -c $ARG2$
}

```

### Configuration check before starting nagios
```
sudo /usr/local/nagios/bin/nagios -v /usr/local/nagios/etc/nagios.cfg
```



### Client Setup

#### Generic uptime

From nagios server run the follwing commands to make sure you get an OK result:

```
check plugin uptime : 	/usr/local/nagios/libexec/check_uptime 192.168.1.200
check plugin ssh:	/usr/local/nagios/libexec/check_ssh  192.168.1.200
```


### Printer setup

For every printer you need a specific file under your printers directory, for example:

sudo vi /usr/local/nagios/etc/printers/hplaserjet.cfg

```
define host{
use                             generic-host
host_name                       hplaserjet
alias                           HP Laserjet
address                         192.168.1.200
max_check_attempts              5
check_period                    24x7
notification_interval           30
notification_period             24x7
}
```



