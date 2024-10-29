FROM debian:buster

# Installation des dépendances
RUN apt-get update && apt-get install -y \
    apache2 \
    php7.3 \
    php7.3-mysql \
    php7.3-mbstring \
    php7.3-xml \
    php7.3-curl \
    default-mysql-server \
    wget \
    unzip \
    && rm -rf /var/lib/apt/lists/*

# Config Apache
RUN a2enmod rewrite
COPY apache2.conf /etc/apache2/sites-available/000-default.conf

# Init bdd
COPY init-db.sh /init-db.sh
RUN chmod +x /init-db.sh && /init-db.sh

# Installation de WordPress
WORKDIR /var/www/html
RUN wget https://wordpress.org/latest.zip && \
    unzip latest.zip && \
    rm latest.zip && \
    chown -R www-data:www-data wordpress

# Installation de phpMyAdmin
RUN wget https://files.phpmyadmin.net/phpMyAdmin/5.1.1/phpMyAdmin-5.1.1-all-languages.zip && \
    unzip phpMyAdmin-5.1.1-all-languages.zip && \
    mv phpMyAdmin-5.1.1-all-languages phpmyadmin && \
    rm phpMyAdmin-5.1.1-all-languages.zip && \
    chown -R www-data:www-data phpmyadmin

# Copie des fichier locaux & donne les permissions a start.sh
COPY index.html /var/www/html/

EXPOSE 80

CMD service mysql start && apachectl -D FOREGROUND