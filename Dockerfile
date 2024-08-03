# Usar a imagem base do Ubuntu mais recente
FROM ubuntu:latest

# Definir o ambiente como não interativo para evitar prompts durante a instalação
ENV DEBIAN_FRONTEND=noninteractive

# Atualizar pacotes e instalar dependências necessárias
RUN apt-get update && apt-get install -y \
    apache2 \
    curl \
    git \
    libfreetype6-dev \
    libicu-dev \
    libjpeg-dev \
    libldap2-dev \
    libmcrypt-dev \
    libmemcached-dev \
    libmysqlclient-dev \
    libpng-dev \
    libpq-dev \
    libxml2-dev \
    openssh-client \
    rsync \
    wget \
    lynx \
    software-properties-common \
    && add-apt-repository ppa:ondrej/php \
    && apt-get update && apt-get install -y \
    php5.6 \
    php5.6-bcmath \
    php5.6-bz2 \
    php5.6-calendar \
    php5.6-exif \
    php5.6-gd \
    php5.6-intl \
    php5.6-mbstring \
    php5.6-mcrypt \
    php5.6-mysql \
    php5.6-mysqli \
    php5.6-opcache \
    php5.6-pgsql \
    php5.6-soap \
    php5.6-xml \
    php5.6-zip \
    php-pear \
    && pecl install memcached-2.2.0 redis \
    && echo "extension=memcached.so" > /etc/php/5.6/apache2/conf.d/20-memcached.ini \
    && echo "extension=redis.so" > /etc/php/5.6/apache2/conf.d/20-redis.ini \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Habilitar módulos do Apache
RUN a2enmod rewrite headers ssl proxy proxy_http

# Instalar Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && ln -s $(composer config --global home) /root/composer

# Configurar ambiente para Composer
ENV PATH=$PATH:/root/composer/vendor/bin COMPOSER_ALLOW_SUPERUSER=1

# Adicionar configuração sysctl para aumentar o número máximo de arquivos
RUN echo "fs.file-max = 500000" >> /etc/sysctl.conf

# Adicionar script de inicialização para definir ulimit
RUN echo '#!/bin/bash\nulimit -n 100000\nexec "$@"' > /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

# Configurar o Apache para exibir o status do servidor
COPY default.conf /etc/apache2/sites-available/000-default.conf
RUN a2ensite 000-default

# Usar o script de inicialização personalizado
ENTRYPOINT ["/docker-entrypoint.sh"]
CMD ["apache2-foreground"]