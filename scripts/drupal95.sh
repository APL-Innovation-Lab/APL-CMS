#!/bin/bash
GIT_ROOT="$(dirname "$(dirname "$0")")"
cd "$GIT_ROOT" 

# In case it isn't already, start colima
colima start

# Script to set up a Drupal project with DDEV
# Usage: ./drupal95.sh [project-name]

# Find the Git project root directory
PROJECT_ROOT=$(git rev-parse --show-toplevel)

# Extract the name of the project directory to use as the default project name
DEFAULT_PROJECT_NAME=$(basename "$PROJECT_ROOT")

# Check if a project name is provided as a parameter
PROJECT_NAME=${1:-"$DEFAULT_PROJECT_NAME"}

# Define Drupal version and project directory
DRUPAL_VERSION="9.5"
PROJECT_DIR="$HOME/$PROJECT_NAME"

echo "Setting up project: $PROJECT_NAME in directory: $PROJECT_DIR"


# Check if the provided project name is different from the default
if [ "$PROJECT_NAME" != "$DEFAULT_PROJECT_NAME" ]; then
    # Define the new directory path
    NEW_DIR_PATH="$PROJECT_DIR"

    # Create the new directory
    mkdir -p "$NEW_DIR_PATH"

fi
# Navigate to the project directory
cd "$PROJECT_DIR" || {
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

# Initialize composer.json with basic project settings
ddev composer init --description "APL Innovation Lab baseline project" --type "project" --stability stable --license "GPL-2.0-or-later" --no-interaction

# Allow necessary plugins
ddev composer config allow-plugins.composer/installers true
ddev composer config allow-plugins.drupal/core-composer-scaffold true

# Update composer configurations
ddev composer update

# Create a Drupal project with the specified version. Drupal will be installed in the 'html' directory as per installer-paths configuration
echo "Creating Drupal project..."
ddev composer require -W "drupal/core-recommended:^$DRUPAL_VERSION"

# Add Drupal core and necessary packages
ddev composer require drupal/core-composer-scaffold:^9
ddev composer require composer/installers:^1.9 -n

# Require Drush using Composer
ddev composer require "drush/drush:^11"

# Restart DDEV to make sure it picks up the config settings
#ddev restart

# Install Drupal via Drush with predefined database credentials. Assumes Drupal is in the 'html' directory.
echo "Installing Drupal..."
ddev drush site:install standard \
  --db-url=mysql://db:db@db:3306/db \
  --site-name="$PROJECT_NAME" \
  --account-name=admin \
  --account-pass=111 -y

# Path to the custom module directory in the repository
CUSTOM_MODULE_SRC="${PROJECT_ROOT}/scripts/modules/custom"

# Path to the custom module directory in the Drupal installation
CUSTOM_MODULE_DEST="${PROJECT_DIR}/modules/custom"

echo "Copying from: $CUSTOM_MODULE_SRC"
echo "Copying to: $CUSTOM_MODULE_DEST"

# Create the custom module directory if it doesn't exist
mkdir -p "$CUSTOM_MODULE_DEST"

# Check if the source directory exists
if [ -d "$CUSTOM_MODULE_SRC" ]; then
    echo "Source directory found. Proceeding with copy."
    # Copy the custom module to the Drupal installation
    cp -r "$CUSTOM_MODULE_SRC" "$CUSTOM_MODULE_DEST"
else
    echo "Source directory not found. Check the path: $CUSTOM_MODULE_SRC"
fi


# Enable the custom module
ddev drush cr
ddev drush en hi_how_are_you -y

# Run the custom Drush command
ddev drush hhay-cn


# Provide information about accessing the site
ddev describe
ddev launch


# Display a success message
echo "--~~~~~~~~~~~~~~~----------~~~~~~~~~~~~~~~~~~~~~~~---"
echo "True love will find you in the end. --Daniel Johnston"
echo "---~~~~~~~~~~~-------~~~~~~~~~~~~~~~~----~~~~~~~~~~~-"