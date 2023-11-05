# DockerDeployment
Automated Installation of Docker Containers for Home.

# Dependancies
- External (NAS) storage with a "Books", "Media", and "Torrents" share.
- Ubuntu Headless Virtual Machine with:
  - A second disk for Plex transcoding (No partitions required - the script will configure this, just need to enter the path when prompted)
  - Docker installed. Note, do not use the snap version of Docker!
 
# Install Docker (Copy paste the below)
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update

# Script Usage
If the host address is going to be 192.168.0.20, copy and paste the below into the terminal:
  - *sudo apt install unzip && wget https://github.com/DarylGraves/DockerDeployment/archive/refs/heads/main.zip && unzip main.zip && chmod 777 DockerDeployment-main/RunMe.sh && sudo DockerDeployment-main/RunMe.sh*

If the host address is going to be diffferent this needs updating before running the script: 
  - *sudo apt install unzip && wget https://github.com/DarylGraves/DockerDeployment/archive/refs/heads/main.zip && unzip main.zip && chmod 777 DockerDeployment-main/RunMe.sh*
  - Update the IP addresses in the nginx sites-available
  - *sudo DockerDeployment-main/RunMe.sh*
