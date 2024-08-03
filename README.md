# docker-php5.5apache

## Build image

```
docker build -t jeffersonmello/php55apache:latest .
```

## Run container

To run the container on ports 80 and 443, use the following command:

```
docker run -p 80:80 -p 443:443 jeffersonmello/php55apache:latest
```

This will map the host's ports 80 and 443 to the container's ports 80 and 443 respectively.