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

# Configuration de MySQL
RUN service mysql start && \
    mysql -e "CREATE DATABASE wordpress;" && \
    mysql -e "CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'password';" && \
    mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wpuser'@'localhost';" && \
    mysql -e "FLUSH PRIVILEGES;"

RUN a2enmod rewrite

COPY apache2.conf /etc/apache2/sites-available/000-default.conf

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

# Copie des fichier locaux
COPY index.html /var/www/html/
COPY start.sh /start.sh

RUN chmod +x /start.sh

EXPOSE 80

CMD ["/start.sh"]