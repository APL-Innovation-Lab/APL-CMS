#!/bin/bash

# Script to set up a Drupal project with DDEV
# Usage: ./setup-drupal.sh [project-name]

# Check if a project name is provided as a parameter, otherwise use default
PROJECT_NAME=${1:-"my-drupal-project"}

# Define Drupal version and project directory
DRUPAL_VERSION="9.5"
PROJECT_DIR="$HOME/$PROJECT_NAME"

echo "Setting up project: $PROJECT_NAME in directory: $PROJECT_DIR"

# Create the project directory and navigate into it
mkdir -p "$PROJECT_DIR" && cd "$PROJECT_DIR" || {
    echo "Failed to navigate to project directory. Exiting."
    exit 1
}

# Create the .ddev directory
mkdir -p .ddev && cd .ddev || {
    echo "Failed to create or navigate to .ddev directory. Exiting."
    exit 1
}

# Create a DDEV config.yaml file with the specified configurations
echo "Creating DDEV configuration..."
cat <<EOT > config.yaml
name: $PROJECT_NAME
type: drupal9
docroot: html
php_version: "8.0"
webserver_type: apache-fpm
database:
  type: mysql
  version: "8.0"
EOT

# Navigate back to the project directory
cd "$PROJECT_DIR"

# Check if config.yaml was created
if [[ ! -f .ddev/config.yaml ]]; then
    echo "Failed to create .ddev/config.yaml. Exiting."
    exit 1
fi

# Start the DDEV environment
echo "Starting DDEV..."
ddev start
composer config allow-plugins.composer/installers true
ddev composer require composer/installers:"^1.9" -n
ddev composer require drupal/core-composer-scaffold:"^9"

# Require Drush using Composer
ddev composer require "drush/drush:^10"

# Restart DDEV to make sure it picks up the config settings
ddev restart

# Create a Drupal project with the specified version
echo "Creating Drupal project..."
ddev composer require -W "drupal/core-recommended:^$DRUPAL_VERSION"

# Navigate back to the project directory
cd "$PROJECT_DIR"

# Create the 'html' subdirectory for Drupal installation
mkdir -p html
cd html

# Install Drupal via Drush with predefined database credentials
echo "Installing Drupal..."
ddev drush site:install standard \
  --db-url=mysql://db:db@db:3306/db \
  --site-name="$PROJECT_NAME" \
  --account-name=admin \
  --account-pass=admin \
  -y


# Provide information about accessing the site
echo "DDEV environment setup complete. You can access your site with the following URL:"
ddev describe
ddev launch