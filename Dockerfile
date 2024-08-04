FROM jeffersonmello/php55apache

RUN rm /etc/apt/sources.list \
    && apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 7638D0442B90D010 8B48AD6246925553 CBF8D6FD518E17E1 \
    && echo "deb http://archive.debian.org/debian/ jessie main" > /etc/apt/sources.list \
    && echo "deb-src http://archive.debian.org/debian/ jessie main" >> /etc/apt/sources.list \
    && echo 'Acquire::Check-Valid-Until "false";' > /etc/apt/apt.conf.d/99no-check-valid-until \
    && echo 'Acquire::AllowInsecureRepositories "true";' > /etc/apt/apt.conf.d/99allow-insecure \
    && echo 'Acquire::AllowDowngradeToInsecureRepositories "true";' >> /etc/apt/apt.conf.d/99allow-insecure \
    && apt-get update --allow-releaseinfo-change \
    && apt-get install -y --allow-downgrades --allow-remove-essential --allow-change-held-packages libfontconfig1 libxrender1 \
    && a2enmod headers