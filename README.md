# twlight_matomo

Matomo analytics for http://wikipedialibrary.wmflabs.org. Based upon [Matomo docker-compose examples](https://github.com/matomo-org/docker#docker-composer-examples-and-log-import-instructions).

## Quick Installation for Developers

- Get [Docker](https://docs.docker.com/get-docker/) and [Docker Compose](https://docs.docker.com/compose/)
- Clone this repository
- From the repository folder, run `docker-compose up`
- See the thing running on [localhost](http://localhost/)
- Get an interactive shell for the `cron` or `app` container:
  - `docker exec -it twlight_matomo_cron_1 sh -l`
  - `docker exec -it twlight_matomo_app_1 sh -l`

## Quick Installation for Debian Servers

Make sure that `/data/project/<environment>` exists. On WMF servers, this is provided by setting `mount_nfs: true` in the instance Hiera configuration.

If you are feeling trustworthy, go ahead and pipe our script directly into a root shell on your server.
What's the worst that could happen?

`sudo bash -c "$(curl -fsSL https://raw.githubusercontent.com/WikipediaLibrary/twlight_matomo/master/bin/debian_swarm_deploy.sh)"`

You should at least check the source at [bin/debian_swarm_deploy.sh](https://github.com/WikipediaLibrary/twlight_matomo/blob/master/bin/debian_swarm_deploy.sh)

Alternatively, you could follow these instructions; the production environment is used in the following examples.

- Configure the upstream [Docker Repository](https://docs.docker.com/install/linux/docker-ce/debian/#install-using-the-repository) and install the latest version of Docker CE
- Install [Docker Compose](https://docs.docker.com/compose/install)
- Add yourself (or your shared system user) to the docker group `sudo usermod -a -G docker ${USER}` then logout and log back in.
- Clone this repository `git clone https://github.com/WikipediaLibrary/twlight_matomo.git` (ideally into a shared directory like `/srv`) and checkout appropriate branch
- `docker swarm init`
- Create secrets, but with real values:
```
printf "This is a secret" | docker secret create MATOMO_DATABASE_USERNAME -
printf "This is a secret" | docker secret create MATOMO_DATABASE_PASSWORD -
printf "This is a secret" | docker secret create MYSQL_ROOT_PASSWORD -
```
- deploy for your environment `docker stack deploy -c docker-compose.yml -c docker-compose.production.yml production`
  - Repeat this step if you add secrets after deployment or update your docker-compose files.
  
## Common tasks
- Restore state from a backup `docker exec -it $(docker ps -q -f name=production_cron) restore.sh fqdn.yyyy-mm-dd-hh-MM.tar.gz`
- Manually start a backup `docker exec -it $(docker ps -q -f name=production_cron) backup.sh`
- Get an interactive shell for the `cron` or `app` container:
  - `docker exec -it $(docker ps -q -f name=production_cron) sh -l`
  - `docker exec -it $(docker ps -q -f name=production_app) sh -l`

## Documentation
 - [Matomo](https://matomo.org/docs/)
 - [Tracking Introduction](https://developer.matomo.org/guides/tracking-introduction)
