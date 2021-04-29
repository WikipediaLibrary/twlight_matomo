#!/usr/bin/env bash
# Installs dependencies and deploys twlight_matomo to a single Debian host.

# Ensure the docker repo will be usable.
apt install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
# Add the apt key
curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -
# Add the apt repo
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/debian $(lsb_release -cs) stable"
# Update
apt update && apt upgrade -y

# Install docker
apt install -y docker-ce docker-ce-cli containerd.io

# Cleanup unneeded packages
apt autoremove -y

# Install docker compose
latest=$(curl https://api.github.com/repos/docker/compose/releases/latest | jq -r '.tag_name')
curl -L "https://github.com/docker/compose/releases/download/${latest}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose

# Add matomo user
adduser matomo --disabled-password --quiet --gecos "" ||:
usermod -a -G docker matomo

# Pull twlight_matomo code and make matomo user the owner
cd /srv
git clone https://github.com/WikipediaLibrary/twlight_matomo.git ||:
cd /srv/twlight_matomo
# Get on correct branch
echo "Enter git branch:"
read MATOMO_GIT_BRANCH
git checkout "${MATOMO_GIT_BRANCH}" && git pull


echo "Enter MATOMO_DATABASE_USERNAME:"
read MATOMO_DATABASE_USERNAME
echo "Enter MATOMO_DATABASE_PASSWORD:"
read MATOMO_DATABASE_PASSWORD
echo "Enter MYSQL_ROOT_PASSWORD:"
read MYSQL_ROOT_PASSWORD
echo "Enter stack environment (eg. override \| staging \| production):"
read MATOMO_STACK_ENV

chown -R matomo:matomo /srv/twlight_matomo

read -r -d '' MATOMO <<- EOF

docker swarm init
# drop any existing services
docker service ls -q | xargs docker service rm
# drop any existing secrets
docker secret ls -q | xargs docker secret rm

cd /srv/twlight_matomo
printf "${MATOMO_DATABASE_USERNAME}" | docker secret create MATOMO_DATABASE_USERNAME -
printf "${MATOMO_DATABASE_PASSWORD}" | docker secret create MATOMO_DATABASE_PASSWORD -
printf "${MYSQL_ROOT_PASSWORD}" | docker secret create MYSQL_ROOT_PASSWORD -

docker stack deploy -c "docker-compose.yml" -c "docker-compose.${MATOMO_STACK_ENV}.yml" "${MATOMO_STACK_ENV}"
EOF
sudo su --login matomo /usr/bin/env bash -c "${MATOMO}"
