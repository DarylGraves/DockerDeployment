# DockerDeployment
Automated Installation of Docker Containers for Home.

# Dependancies
- External (NAS) storage with a "Books", "Media", and "Torrents" share.
- Ubuntu Headless Virtual Machine with:
  - A second disk for Plex transcoding (No partitions required - the script will configure this, just need to enter the path when prompted)
  - Docker installed ( *sudo apt-get install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin* )

# Usage
If the host address is going to be 192.168.0.20, copy and paste the below into the terminal:
  - *sudo apt install unzip && wget https://github.com/DarylGraves/DockerDeployment/archive/refs/heads/main.zip && unzip main.zip && chmod 777 DockerDeployment-main/RunMe.sh && sudo DockerDeployment-main/RunMe.sh*

If the host address is going to be diffferent this needs updating before running the script: 
  - *sudo apt install unzip && wget https://github.com/DarylGraves/DockerDeployment/archive/refs/heads/main.zip && unzip main.zip && chmod 777 DockerDeployment-main/RunMe.sh*
  - Update the IP addresses in the nginx sites-available
  - *sudo DockerDeployment-main/RunMe.sh*
