# DockerDeployment
Automated Installation of Docker Containers for Home Lab. Used for Linux headless servers.

# Depandancies
- NAS with a "Books", "Media", and "Torrents" share.
- Virtual Machine with a second disk for Plex transcoding. Second disk not yet provisioned

# Usage
Run the below commands in the Terminal:
- sudo apt install unzip
- wget https://github.com/DarylGraves/DockerDeployment/archive/refs/heads/main.zip
- unzip main.zip
- chmod 777 DockerDeployment-main/RunMe.sh
- sudo DockerDeployment-main/RunMe.sh
