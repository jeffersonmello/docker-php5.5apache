# php5.5

Docker container with php 5.5 and apache

## Build image

```
docker build -t jeffersonmello/php5.5:latest .
```

## Run container

To run the container on ports 80 and 443, use the following command:

```
docker run -p 80:80 -p 443:443 jeffersonmello/php5.5:latest
```

This will map the host's ports 80 and 443 to the container's ports 80 and 443 respectively.


## How to publish

````
docker push jeffersonmello/php5.5:latest
```
