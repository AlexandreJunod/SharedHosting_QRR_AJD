# Installation of a server web on Debian 9.3.0

## Requirement
   1. ISO image of Debian 9.3.0 (amd64)
    *you can download debian iso on https://www.debian.org/distrib/netinst*


## VMWare Installation
   **Only follow theses steps if you are installing your OS on VMware Workstation 12**
   - On VMware : File → New virtual machine
   - Virtual Machine Configuration → Custom (advanced)
   - Hardware compatibility → Workstation 12.0
   - Install from → Installer disc image (iso) → **your path to the Debian ISO**
   - Guest Operating System → Linux
   - Version → Debian [last version] 64-bit
      - I've chose → version → Debian 8.x 64-bit
   - Virtual machine name → **NAME**
   - Location → **Where you want**
   - Number of processors → 1
   - Memory → 1024 MB
   - Network Connection → Use network address translation (NAT)
   - I/O Controller Types → LSI Logic (Recommended)
   - Virtual Disk Type → SCSI (Recommended)
   - Disk → Create a new virtual disk
   - Disk Size → Maximum disk size (in GB) → 20.0
   - Split virtual disk into multiple files
   - Disk File → **NAME**.vmdk
    - Customize Hardware
      - Remove → USB Controller
      - Remove → Sound Card
      - Remove → Printer


## Debian Installation

### Choice of country and language
   - Power on the Debian OS
   - Debian GNU/Linux installer boot menu → Install
   - Language → **LANGUAGE**
   - Country, territory or area → **COUNTRY**
   - Keymap to use → **YOUR KEYMAP**
   - Hostname →  **NAME**
   - Domain name → Let it empty


### Choice of root and user account
   - Root password → **PASSWORD**
   - Re-enter password to verify → **PASSWORD**
   - Full name for the new user → **USER FULL NAME**
   - Username for your account → **USERNAME**
   - Choose a password for the new user → **PWD USER**
   - Re-enter password to verify → **PWD USER**


### Partitioning disks  
   - Partitionning disks → Guided - use entire disk and set up LVM. *LVM (Logical Volume Manager)     concist on goup all physical disks or partitions in one big volume in which you can make logical partitions how many times you want and edit them. So whe use it to be able to extend the storage space*
   - Select disk to partition → SCSI3 (0,0,0) (sda) - 21.5 GB VMware, VMware Virtual S
   - Partitionning scheme → Separate /home, /var, and /tmp partitions. *Separate /home and /var to be able to migrate system without losing user or website*
   - Write the changes to disks and configure LVM? → Yes
   - Choose → Finish partitioning and write change to disk
   - Write the changes to disks → Yes
   - Scan another CD or DVD → No
   - Debian archive miror country → Go Back
   - Continue wirthout a network miror → Yes
   - Participate in the package usage survey? → No


### Software selection
   - Choose software to install → With the **Spacebar** be sure to uncheck the standard system utilities and → Continue
   - Install the GRUB boot loader to the master boot record? → Yes
   - Device for boot loader installation → /dev/sda
   - Finish the installation → Continue

   Now, the installation is finish
   **It's safer to take a snapshot of the VM if you're using VMware**


### Configuration ip, connected as root
   ```bash
   nano /etc/network/interfaces
   ```
   - Put everything like in the example under (You have to put your **IP, Netmask, Gateway**) :
   ```bash
      # This file describes the network interfaces available on your system
      # and how to activate them. For more information, see interfaces(5).

      source /etc/network/interfaces.d/*

      # The loopback network interface
      auto ens32
      iface ens32 inet static
              address 172.17.218.69
              netmask 255.255.0.0
              gateway 172.17.0.1

      # The primary network interface
      allow-hotplug ens32
      iface ens32 inet dhcp
   ```
   - VM → Settings → Network Adapter → Bridged
   ```bash
   reboot
   ```


## Package install

### Change server packages distribution, connected as root
   ```bash
   nano /etc/apt/sources.list
   ```
   - Put everything in comment with "#" and add :
   ```bash
   deb http://debian.ethz.ch/debian stable main contrib non-free
   ```


### Update the list of packages know by the system, connected as root
   ```bash
   apt-get update && apt-get upgrade
   ```


### Sudo to be able to install/configura without be logged as root
   ```bash
   apt-get install sudo
   adduser cpnv sudo
   reboot
   ```


### SSH to work
   ```bash
   sudo apt-get install ssh
   ```


### Maria DB
   ```bash
   sudo apt-get install mariadb-server   
   ```

### NGINX
   ```bash
   sudo apt install nginx
   sudo service nginx start
   ---
   pas oublié de changer root et retiré html pour le faire lire au bon endroit
   rajouter /html/ au site par default
   créer un nouveau avec /$USER/
   droits 700 -R pour recursive
   appartenance a $USER:$USER -R
   ```


### PHP - FPM
   ```bash
   sudo apt install php7.0 php7.0-common php7.0-cli php7.0-fpm
   ```

## How did we isolate the users
We have first proceed by creating new users, and next we have changed the home direcory of all users on 700 to prevent intrusions by other users.

For the maria db we create every time a new user and a new db and he is the only one who had all permissions of his db.

For the website and create every time a folder, next we change the owner and then we give him all rights and remove rights to others and group.

We create a new site for every user linked on his own php pool

And for the pool, we configure it for the user who will use it

## How to proced when a client want an espace
### New user
- Add a new user
```bash
sudo adduser USERNAME
```
Unix password is the password for the user, you can put a **temporary password**.
You can just press enter on : *Full Name*, *Room Number*, *Work Phone*, *Home Phone* and *Other*.

- Change directory permissions
```bash
sudo chmod 700 /home/USERNAME
```

- Create website reportory
```bash
sudo mkdir /var/www/USERNAME
```

- If you want you can put a page index.html and a page php
```bash
sudo nano /var/www/USERNAME/index.html
sudo nano /var/www/USERNAME/default.php
```

- Change permissions and owner
```bash
sudo chmod 700 -R /var/www/USERNAME/
sudo chown USERNAME:USERNAME -R /var/www/USERNAME/
```

### Maria DB
- Create a DB for the ner user, first connect
```bash
sudo mysql -u root -p
```

- Create the db and give privileges
```sql
CREATE DATABASE USERNAME-DB;
CREATE USER 'USERNAME'@'localhost' IDENTIFIED BY 'password';
GRANT ALL PRIVILEGES ON USERNAME-DB.* TO USERNAME@localhost;
FLUSH PRIVILEGES;
quit
```

- Allow the user to connect on the DB from remote host
```sql
GRANT ALL PRIVILEGES ON USERNAME DB.* TO USERNAME@'%' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
quit
```

### Nginx
- Create a new site with the copy command
```bash
sudo cp /etc/nginx/sites-available/default /etc/nginx/sites-available/USERNAME
```

- Edit the file created
```bash
sudo nano /etc/nginx/sites-available/USERNAME
```

- And edit to put the site like this
````bash
server {
        listen 80;
        listen [::]:80;

        # SSL configuration
        #
        # listen 443 ssl default_server;
        # listen [::]:443 ssl default_server;
        #
        # Note: You should disable gzip for SSL traffic.
        # See: https://bugs.debian.org/773332
        #
        # Read up on ssl_ciphers to ensure a secure configuration.
        # See: https://bugs.debian.org/765782
        #
        # Self signed certs generated by the ssl-cert package
        # Don't use them in a production server!
        #
        # include snippets/snakeoil.conf;
	     root /var/www/USERNAME/;

        # Add index.php to the list if you are using PHP
        index index.html index.htm;

        server_name USERNAME.com;

		location / {
                try_files $uri $uri/ =404;
        }

        location ~ \.php$ {
                try_files $uri $uri/ =404;
                fastcgi_pass unix:/var/run/php/php7.0-fpm-USERNAME.sock;
                fastcgi_index index.php;
                fastcgi_param SCRIPT_FILENAME $document_root$fastcgi_script_name;
                include fastcgi_params;
                fastcgi_param PATH_INFO $uri;
        }
````
- Create an alias to enable the site
```bash
sudo ln -s /etc/nginx/sites-available/USERNAME /etc/nginx/sites-enabled/
```

### Php pool
- Create a new pool for the user
```bash
sudo cp /etc/php/7.0/fpm/pool.d/www.conf /etc/php/7.0/fpm/pool.d/USERNAME.conf
```

- Edit the pool
```bash
sudo nano /etc/php/7.0/fpm/pool.d/USERNAME.conf
```

- And edit to put the site like this

; Start a new pool named 'www'.
; the variable $pool can be used in any directive and will be replaced by the
; pool name ('www' here)
[USERNAME]

; Per pool prefix
; It only applies on the following directives:
; - 'access.log'
; - 'slowlog'
; - 'listen' (unixsocket)
; - 'chroot'
; - 'chdir'
; - 'php_values'
; - 'php_admin_values'
; When not set, the global prefix (or /usr) applies instead.
; Note: This directive can also be relative to the global prefix.
; Default Value: none
;prefix = /path/to/pools/$pool

; Unix user/group of processes
; Note: The user is mandatory. If the group is not set, the default user's group
;       will be used.
user = USERNAME
group = USERNAME
; The address on which to accept FastCGI requests.
; Valid syntaxes are:
;   'ip.add.re.ss:port'    - to listen on a TCP socket to a specific IPv4 address on
;                            a specific port;
;   '[ip:6:addr:ess]:port' - to listen on a TCP socket to a specific IPv6 address on
;                            a specific port;
;   'port'                 - to listen on a TCP socket to all addresses
;                            (IPv6 and IPv4-mapped) on a specific port;
;   '/path/to/unix/socket' - to listen on a unix socket.
; Note: This value is mandatory.
listen = /run/php/php7.0-fpm-USERNAME.sock


- Restart the services
```bash
sudo service php7.0-fpm restart
sudo service nginx restart
```

- On windows on the host file add
```bash
YOUR ADDRESS USERNAME.com
```

- Connect to the site
http://USERNAME.com
