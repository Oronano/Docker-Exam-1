#!/bin/bash

# Démarrage des services
service mysql start

# service apache2 start
apachectl -D FOREGROUND