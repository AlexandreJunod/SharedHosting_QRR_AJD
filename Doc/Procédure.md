# Installation of a server web on Debian 9.3.0

## Requirement
   1. ISO image of Debian 9.3.0 (amd64)
    *you can download debian iso on https://www.debian.org/distrib/netinst*

## VMWare Installation
   **Only follow theses steps if you are installing your OS on VMware Workstation 12**
   - On VMware : File → New virtual machine
   - Virtual Machine Configuration → Custom (advanced)
   - Hardware compatibility → Workstation
   - Install from → Installer disc image (iso) → **your path to the Debian ISO**
   - Guest Operating System → Linux
   - Version → Debian [last version] 64-bit
      - I've chose → version → Debian 8.x 64-bit
   - Virtual machine name → SharedHosting_ **NAME**
   - Location → **Where you want**
   - Number of processors → 1
   - Memory → 1024 MB
   - Network Connection → Use network address translation (NAT)
   - I/O Controller Types → LSI Logic (Recommended)
   - Virtual Disk Type → SCSI (Recommended)
   - Disk → Create a new virtual disk
   - Disk Size → Maximum disk size (in GB) → 20.0
   - Split virtual disk into multiple files
   - Disk File → SharedHosting_**NAME**.vmdk
      - Customize Hardware
      - Enlever → USB Controller
      - Enlever → Sound Card
      - Enlever → Printer

## Debian Installation

### Choice of country and language
   - Power on the Debian OS
   - Debian GNU/Linux installer boot menu → Install
   - Language → English - English
   - Country, territory or area → United States
   - Keymap to use → Swiss French. *It's important to get a **QWERTZ** keyboard*
   - Hostname → SharedHosting- **NAME**
   - Domain name → Let it empty


### Choice of root and user account
   - Root password → root. *It's an example, for security use a true password*
   - Re-enter password to verify → root
   - Full name for the new user → cpnv
   - Username for your account → cpnv
   - Choose a password for the new user → cpnv. *It's an example, for security use a true password*
   - Re-enter password to verify → cpnv
   - Select your time zone → Central


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
   **Take a snapshot of the VM if you're using VMware**

### Configuration ip
   ```bash
   # nano /etc/network/interfaces
   ```
   - Put everything like in the example under (You can put another **IP, Netmask, Gateway**) :
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
   # reboot
   ```

## Package install

### Change server packages distribution
   ```bash
   # nano /etc/apt/sources.list
   ```
   - Put everything in comment with "#" and add :
   ```bash
   deb http://debian.ethz.ch/debian stable main contrib non-free
   ```

### Update the list of packages know by the system
   ```bash
   # apt-get update && apt-get upgrade
   ```

### Sudo to be able to install/configura without be logged as root
   ```bash
   # apt-get install sudo
   # adduser cpnv sudo
   # reboot
   ```

### SSH to work
   ```bash
   $ sudo apt-get install ssh
   ```

### Maria DB
#### Installation
   ```bash
   $ sudo apt-get install mariadb-server   
   ```
#### Configuration
   - Connecter to the DB (Password is the password of root user)
   ```bash
   # mysql -u root -p
   ```
#### Create a new DB, new user and give all the privileges of the DB on the user
   ```sql
   //Enter line after line
   CREATE DATABASE testdb;
   CREATE USER 'testuser'@'localhost' IDENTIFIED BY 'password';
   GRANT ALL PRIVILEGES ON testdb.* TO testuser@localhost;
   FLUSH PRIVILEGES;
   quit
   ```
#### Allow the user to connect on the DB from remote host
   ```sql
   //Enter line after line
   GRANT ALL PRIVILEGES ON testdb.* TO testuser@'%' IDENTIFIED BY 'secretpassword';
   FLUSH PRIVILEGES;
   quit
   ```
#### Login with testuser on the DB testdb
   ```bash
   # mysql -u testuser -p (the password is password)
   ```
   ```sql
   USE testdb;
   ```

### NGINX
   ```bash
   # sudo apt install ngyinx
   # service nginx start
   ```

### PHP - FPM
   ```bash
   $ sudo apt install php7.0 php7.0-common php7.0-cli php7.0-fpm
   ```
