
# Drupal Project Setup Script Documentation

This documentation provides an overview of the bash script used for setting up a Drupal project with DDEV. The script is designed to automate the process of creating a Drupal environment, making it easier and more efficient.

## Script Overview

The script performs the following actions:

1. **Checks for CLI Parameter**: If a project name is provided as a command-line argument, it uses that name; otherwise, it defaults to "my-drupal-project".
2. **Creates Project Directory**: It creates a directory for the project in the user's home directory.
3. **Navigates to Project Directory**: The script then navigates into the project directory.
4. **Creates .ddev Directory and Config**: Inside the project directory, a `.ddev` folder is created, and a `config.yaml` file is set up for DDEV configuration.
5. **Checks for Config Creation**: The script verifies if the `config.yaml` was successfully created.
6. **Starts DDEV Environment**: Initiates the DDEV environment.
7. **Updates `composer.json` Requirements**: The script updates the `composer.json` template with required modules.
8. **Installs Drupal via Composer and Drush**: It uses Composer to require Drupal and Drush, then installs Drupal using Drush.

## Usage

To use the script, navigate to your repository's root directory and run the script as follows:

```
./drupal95.sh
```

This will use the default project name "my-drupal-project". 

### Custom Project Name

To specify a custom project name, provide it as an argument when running the script:

```
./drupal95.sh custom-project-name
```

Replace `custom-project-name` with your desired project name.

## Example

Running the script with a custom project name:

```
./drupal95.sh my-amazing-drupal-site
```

This command will set up a Drupal project named "my-amazing-drupal-site" in the user's home directory.

## Notes

- Ensure that the script has execute permissions: `chmod +x setup-drupal.sh`.
- Make sure you are in the root directory of your repository before running the script.
- The script is designed for a Unix-like environment and may need adjustments for other systems.
