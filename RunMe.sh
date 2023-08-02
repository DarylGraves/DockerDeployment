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
    echo "Setting up secondary disk"
    read -p "Second disk location (e.g. /dev/sdb )" SECONDDISK
    mkfs -t ext3 $SECONDDISK
    echo "$SECONDDISK /media/plex ext4 defaults 0 1\n" >> /etc/fstab
    mount -a
fi

if [ ! -d /media/plex/config ]; then
    echo "Making /media/plex/config"
    mkdir /media/plex/config
fi

if [ ! -d /media/plex/cache ]; then
    echo "Making /media/plex/cache"
    mkdir /media/plex/cache
fi

# Create NAS mappings
if [ ! -d /media/nas_media ]; then
    echo "Making /media/nas_media"
    mkdir /media/nas_media
fi

if [ ! -d /media/nas_books ]; then
    echo "Making /media/nas_books"
    mkdir /media/nas_books
fi

if [ ! -d /media/nas_torrents ]; then
    echo "Making /media/nas_torrents"
    mkdir /media/nas_torrents
fi

# Keeping private details outside of the script
read -p 'IP Address of NAS: ' IP

# Adding drive mounting into fstab config
echo "Adding mappings into fstab..."
if ! grep nas_media /etc/fstab; then
    printf "//%s/Media/ /media/nas_media cifs credentials=/root/.smbcred_media,iocharset=utf8 0 0\n" $IP >> /etc/fstab
fi

if ! grep nas_books /etc/fstab; then
    printf "//%s/Books/ /media/nas_books cifs uid=1000,nobrl,credentials=/root/.smbcred_books,iocharset=utf8,file_mode=0777,dir_mode=0777,noperm 0 0\n" $IP >> /etc/fstab
fi

if ! grep nas_torrents /etc/fstab; then
    printf "//%s/Torrents/ /media/nas_torrents cifs credentials=/root/.smbcred_torrent,iochartset=utf8 0 0\n" $IP >> /etc/fstab
fi

# Prompting user for credentials and storing them in Root's Home Directory
if [ ! -f /root/.smbcred_books]; then
    echo "Credentials for NAS Books:"
    read -p "Username: " BOOKUSERNAME
    read -p "Password: " BOOKPASSWORD
    printf "username=%s\npassword=%s" $BOOKUSERNAME $BOOKPASSWORD > /root/.smbcred_books
fi

if [ ! -f /root/.smbcred_media]; then
    echo "Credentials for NAS Media:"
    read -p "Username: " MEDIAUSERNAME
    read -p "Password: " MEDIAPASSWORD
    printf "username=%s\npassword=%s" $MEDIAUSERNAME $MEDIAPASSWORD > /root/.smbcred_media
fi

if [ ! -f /root/.smbcred_torrent]; then
    echo "Credentials for NAS Torrents:"
    read -p "Username: " TORRENTUSERNAME
    read -p "Password: " TORRENTPASSWORD
    printf "username=%s\npassword=%s" $TORRENTUSERNAME $TORRENTPASSWORD > /root/.smbcred_torrent
fi

mount -a

# Now attempt to start the containers
chmod 777 ./RunContainers.sh
./RunContainers.sh