# Installation of a server web on Debian 9.3.0

## Requirement
   1. ISO image of Debian 9.3.0 (amd64)
      2.

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
   - Power on the Debian OS
