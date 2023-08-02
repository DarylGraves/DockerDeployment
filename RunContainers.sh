# Portainer Docker:
echo "Starting Portainer Docker container..."
docker volume create portainer_data
docker run -d \
    --name portainer \
    -p 9443:9443 \
    -p 8000:8000 \
    -v /var/run/docker.sock:/var/run/docker.sock \
    -v portainer_data:/data \
    --restart always \
    portainer/portainer-ce:latest

# Calibre Docker:
echo "Starting Calibre Docker container..."
docker run -d \
  --name=calibre \
  -e PUID=1000 \
  -e PGID=1000 \
  -e TZ=Etc/UTC \
  -p 8080:8080 \
  -p 8181:8181 \
  -p 8081:8081 \
  -v /media/nas_books:/config \
  --restart unless-stopped \
  lscr.io/linuxserver/calibre:latest

# Plex Docker:
echo "Starting Plex container..."
docker run -d \
    --name=plex \
    --network=host \
    -e TZ="Europe/London" \
    -v /media/plex/config:/config \
    -v /media/plex/cache:/transcode \
    -v /media/nas_media:/data \
    plexinc/pms-docker

# Nginx Docker:
echo "Starting Nginx container..."
cp DockerDeployment-main/nginx/ /var/ -r
docker run -d \
    --name=nginx \
    -p 80:80 \
    -p 443:443 \
    -v /var/nginx/:/etc/nginx \
    --restart unless-stopped \
    nginx:latest
