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

RUN cd /etc/ssl/certs && curl https://curl.se/ca/cacert.pem --insecure --output cacert.pem && cp ca-certificates.crt ca-certificates.crt.bkp && rm ca-certificates.crt && ln -s /etc/ssl/certs/cacert.pem /etc/ssl/certs/ca-certificates.crt

# Adicionar configuração sysctl para aumentar o número máximo de arquivos
RUN echo "fs.file-max = 500000" >> /etc/sysctl.conf

# Adicionar script de inicialização para definir ulimit
RUN echo '#!/bin/bash\nulimit -n 100000\nexec "$@"' > /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Configuração do Apache para limitar os workers
RUN echo '\
<IfModule mpm_prefork_module>\n\
    StartServers             5\n\
    MinSpareServers          5\n\
    MaxSpareServers         10\n\
    MaxRequestWorkers      150\n\
    MaxConnectionsPerChild   0\n\
</IfModule>' >> /etc/apache2/apache2.conf

# Usar o script de inicialização personalizado
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["apache2ctl", "-D", "FOREGROUND"]