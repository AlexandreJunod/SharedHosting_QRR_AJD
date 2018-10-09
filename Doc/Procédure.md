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

## Package install

### Change server packages distribution
   - # nano /etc/apt/sources.list
   - Put everything in comment with "#" and add :
   deb http://debian.ethz.ch/debian stable main contrib non-free

### Update the list of packages know by the system
   - # apt-get update && apt-get upgrade

### Sudo to be able to install/configura without be logged as root
   - # apt-get install sudo
   - # adduser cpnv sudo
   - # reboot

### SSH to work
   - $ sudo apt-get install ssh
   PAS OUBLIER DE METTRE EN BRIDGE POUR QUE QUENTIN PUISSE SE CONNECTER BRUUUUUUH :skull:

### Maria DB
   -

### NGINX
### PHP - FTM
### SSH (+ ip statique + bridge)
### SUDO
