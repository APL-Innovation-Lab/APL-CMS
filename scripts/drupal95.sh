#!/bin/bash

# in case it isn't already, start colima
# colima start

# Script to set up a Drupal project with DDEV
# Usage: ./setup-drupal.sh [project-name]

# Check if a project name is provided as a parameter, otherwise use default
#PROJECT_NAME=${1:-"my-drupal-project"}

#!/bin/bash

# Find the Git project root directory
PROJECT_ROOT=$(git rev-parse --show-toplevel)

# Extract the name of the project directory to use as the default project name
DEFAULT_PROJECT_NAME=$(basename "$PROJECT_ROOT")

# Check if a project name is provided as a parameter, otherwise use the default
PROJECT_NAME=${1:-"$DEFAULT_PROJECT_NAME"}



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

# Configure installer paths for Drupal components
#ddev composer config extra.installer-paths.html/core "type:drupal-core"

# composer config extra.installer-paths.html/modules/contrib '{"$name": ["type:drupal-module"]}'
# composer config extra.installer-paths.html/profiles/contrib '{"$name": ["type:drupal-profile"]}'
# composer config extra.installer-paths.html/themes/contrib '{"$name": ["type:drupal-theme"]}'
# composer config extra.installer-paths.html/drush/Commands/{$name} '["type:drupal-drush"]'



# Set Drupal scaffold directory
#ddev composer config extra.drupal-scaffold.locations.web-root 'html/'

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

# Provide information about accessing the site
echo "DDEV environment setup complete. You can access your site with the following URL:"
ddev describe
ddev launch

# restore the README.md from the project, instead of the new Drupal one
git checkout HEAD -- README.md


# Display a success message
echo "----------------------------------------"
echo "Setup complete!"
echo "----------------------------------------"