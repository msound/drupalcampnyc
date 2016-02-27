#!/bin/bash

# Usage:
# docker-install.sh
#

cd /var/www/html

# Prepare installation (create settings.php, files folder etc)
drush site-install \
  --db-url="mysql://${DRUPALDEMO_DB_USER}:${DRUPALDEMO_DB_PASS}@${DRUPALDEMO_DB_HOST}/${DRUPALDEMO_DB_NAME}" \
  -y drupalcampnyc install_configure_form.update_status_module='array(FALSE,FALSE)' \
&& chown -R www-data:www-data sites/default/files

