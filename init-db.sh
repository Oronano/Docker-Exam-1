#!/bin/bash
service mysql start

# Créer l'utilisateur et la base de données
mysql -u root <<EOF
CREATE DATABASE wordpress;
CREATE USER 'user'@'localhost' IDENTIFIED BY 'userpassword';
GRANT ALL PRIVILEGES ON wordpress.* TO 'user'@'localhost';
FLUSH PRIVILEGES;
EOF

service mysql stop
