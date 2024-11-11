#!/bin/bash
# Check if the /var/www/html/index.html file exists and remove it
if [ -f /var/www/html/index.html ]; then
    rm /var/www/html/index.html
fi
