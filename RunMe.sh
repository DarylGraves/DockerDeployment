# Check script is running as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

# Check machine has Docker installed
if [ ! -f "$(which docker)" ]; then
    echo "Docker must be installed" >&2
    exit 1
fi

# Check Plex drive exists and is mapped to /media/plex
if [ ! -d \media\plex ]; then
    echo "Script needs the secondary drive (\media\plex) to be partitioned and mounted before continuing"
    echo "Assuming the disk is /dev/sdb, do the following:"
    echo "  sudo mkfs -t ext3 /dev/sdb"
    echo "Once partitioned, copy and paste the below into fstab and then reboot"
    echo "  /dev/sdb /media/plex ext4 defaults 0 1"
    echo "Disk needs a 'config' and 'cache' directory"
    exit 1
fi

# Create NAS mappings
mkdir /media/nas_media
mkdir /media/nas_books
mkdir /media/nas_torrents

# Keeping private details outside of the script
read -p 'IP Address of NAS: ' IP

# Adding drive mounting into fstab config
echo "Adding mappings into fstab..."
printf "//%s/Media/ /media/nas_media cifs credentials=/root/.smbcred_media,iocharset=utf8 0 0\n" $IP >> /etc/fstab
printf "//%s/Books/ /media/nas_books cifs uid=1000,nobrl,credentials=/root/.smbcred_books,iocharset=utf8,file_mode=0777,dir_mode=0777,noperm 0 0\n" $IP >> /etc/fstab
printf "//%s/Torrents/ /media/nas_torrents cifs credentials=/root/.smbcred_torrent,iochartset=utf8 0 0\n" $IP >> /etc/fstab

# Prompting user for credentials and storing them in Root's Home Directory
echo "Credentials for NAS Books:"
read -p "   Username: " BOOKUSERNAME
read -ps "  Password: " BOOKPASSWORD
printf "username=%s\npassword=%s" $BOOKUSERNAME $BOOKPASSWORD > /root/.smbcred_books

echo "Credentials for NAS Media:"
read -p "   Username: " MEDIAUSERNAME
read -ps "  Password: " MEDIAPASSWORD
printf "username=%s\npassword=%s" $MEDIAUSERNAME $MEDIAPASSWORD > /root/.smbcred_media

echo "Credentials for NAS Torrents:"
read -p "   Username: " TORRENTUSERNAME
read -ps "  Password: " TORRENTPASSWORD
printf "username=%s\npassword=%s" $TORRENTUSERNAME $TORRENTPASSWORD > /root/.smbcred_torrent

mount -a

# Now attempt to start the containers
chmod 777 ./RunContainers.sh
./RunContainers.sh