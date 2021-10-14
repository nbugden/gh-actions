# Demo App

### Overview
> App is a simple container.

### Run Locally
> From `src` build the Docker image and run container
```sh
docker-compose up --build
```

> Visit `http://0.0.0.0:8080/<ENDPOINT>` to view route. E.g. `http://0.0.0.0:8080/version` displays a message showing the version of the application that is live

> Tear down container and remove docker networks when done
```sh
docker-compose down
```

> Note: to remove all images (regardless) which service (in `docker-compose.yaml`) uses it, do the following instead:
```sh
docker-compose down --rmi all
```

### Run Test
> From `src` build the Docker image and run container run (tox) [https://tox.readthedocs.io/en/latest/]:
```sh
tox
```
