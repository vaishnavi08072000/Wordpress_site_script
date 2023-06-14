#!/bin/bash

SITE_NAME=$1

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check if Docker is installed
if ! command_exists docker; then
    echo "Docker not found. Installing Docker..."
    curl -fsSL https://get.docker.com -o get-docker.sh
    sudo sh get-docker.sh
    sudo usermod -aG docker $USER
    sudo systemctl enable docker
    sudo systemctl start docker
    echo "Docker installed successfully."
fi

# Check if Docker Compose is installed
if ! command_exists docker-compose; then
    echo "Docker Compose not found. Installing Docker Compose..."
    sudo curl -L "https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose
    echo "Docker Compose installed successfully."
fi

# Create docker-compose.yml
echo "Creating docker-compose.yml..."
cat <<EOF > docker-compose.yml
version: '3'
services:
  db:
    image: mysql:5.7
    volumes:
      - db_data:/var/lib/mysql
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
  wordpress:
    depends_on:
      - db
    image: wordpress
    volumes:
      - ./wp:/var/www/html
    ports:
      - 80:80
    restart: always
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
volumes:
  db_data:
EOF
echo "docker-compose.yml created successfully."

# Create the site directory
mkdir wp

# Start the containers
echo "Starting the containers..."
docker-compose up -d

# Add entry to /etc/hosts
echo "Adding entry to /etc/hosts..."
echo "127.0.0.1   example.com" | sudo tee -a /etc/hosts

# Prompt user to open the site in a browser
echo "Site created successfully."
echo "Please open http://example.com in your browser to access the site."

# Enable/disable site
if [[ $2 == "enable" ]]; then
    echo "Enabling the site..."
    docker-compose start
    echo "Site enabled."
elif [[ $2 == "disable" ]]; then
    echo "Disabling the site..."
    docker-compose stop
    echo "Site disabled."
fi

# Delete site
if [[ $2 == "delete" ]]; then
    echo "Deleting the site..."
    docker-compose down --volumes
    rm -rf wp
    sudo sed -i '/example.com/d' /etc/hosts
    echo "Site deleted."
fi
