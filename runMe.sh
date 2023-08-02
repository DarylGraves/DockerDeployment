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

# Install cifs-utils to map NAS drives
apt install cifs-utils

# Check Plex drive exists and is mapped to /media/plex
if [ ! -d /media/plex ]; then
    echo "Setting up secondary disk..."
    read -p "Second Disk path (e.g. '/dev/sdb' )" SECONDDISK
    mkfs -t ext3 $SECONDDISK
    echo "%s /media/plex ext4 defaults 0 1\n" $SECONDDISK >> /etc/fstab
    mount -a
fi

if [ ! -d /media/plex/config ]; then
    echo "Creating Plex config folder..."
    mkdir /media/plex/config
fi

if [ ! -d /media/plex/cache ]; then
    echo "Creating Plex cache folder..."
    mkdir /media/plex/cache
fi

if [ ! -d /media/nas_media ]; then
    echo "Creating Nas Media folder..."
    mkdir /media/nas_media
fi

if [ ! -d /media/nas_books ]; then
    echo "Creating Nas Books folder..."
    mkdir /media/nas_books
fi

if [ ! -d /media/nas_torrents ]; then
    echo "Creating Nas Torrents folder..."
    mkdir /media/nas_torrents
fi

# Keeping private details outside of the script
read -p 'IP Address of NAS: ' IP

# Adding drive mounting into fstab config
echo "Adding mappings into fstab..."
printf "//%s/Media/ /media/nas_media cifs credentials=/root/.smbcred_media,iocharset=utf8 0 0\n" $IP >> /etc/fstab
printf "//%s/Books/ /media/nas_books cifs uid=1000,nobrl,credentials=/root/.smbcred_books,iocharset=utf8,file_mode=0777,dir_mode=0777,noperm 0 0\n" $IP >> /etc/fstab
printf "//%s/Torrents/ /media/nas_torrents cifs credentials=/root/.smbcred_torrent,iochartset=utf8 0 0\n" $IP >> /etc/fstab

# Prompting user for credentials and storing them in Root's Home Directory
if [ ! -f /root/.smbcred_books ]; then
    echo "Credentials for NAS Books:"
    read -p "   Username: " BOOKUSERNAME
    read -p "  Password: " BOOKPASSWORD
    printf "username=%s\npassword=%s" $BOOKUSERNAME $BOOKPASSWORD > /root/.smbcred_books
fi


if [ ! -f /root/.smbcred_media ]; then
    echo "Credentials for NAS Media:"
    read -p "   Username: " MEDIAUSERNAME
    read -p "  Password: " MEDIAPASSWORD
    printf "username=%s\npassword=%s" $MEDIAUSERNAME $MEDIAPASSWORD > /root/.smbcred_media
fi

if [ ! -f /root/.smbcred_torrent ]; then
    echo "Credentials for NAS Torrents:"
    read -p "   Username: " TORRENTUSERNAME
    read -p "  Password: " TORRENTPASSWORD
    printf "username=%s\npassword=%s" $TORRENTUSERNAME $TORRENTPASSWORD > /root/.smbcred_torrent
fi

mount -a

# Now attempt to start the containers
chmod 777 ./RunContainers.sh
./RunContainers.sh