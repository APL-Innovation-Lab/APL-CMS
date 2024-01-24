# Custom Modules for APL-CMS

This section of the APL-CMS repository is dedicated to custom modules developed for our Drupal-based website. Custom modules allow us to extend the functionality of Drupal, tailoring it to meet our specific needs.

## Module Placement
All custom modules should be placed in the `[core]/modules/custom` directory of your Drupal installation. This directory is reserved for modules that are not part of the Drupal core or contributed modules from the Drupal community. By placing custom modules in this directory, we ensure a clear separation between core, contributed, and custom functionalities.

## Enabling and Disabling Modules

### Using DDEV
DDEV is a Docker-based development environment that simplifies the management of PHP applications like Drupal. To enable or disable modules using DDEV, follow these steps:

1. **Start DDEV**: Navigate to the root directory of your Drupal installation and start DDEV using `ddev start`.

2. **SSH into the Container**: Access the container's shell by running `ddev ssh`.

3. **Enable a Module**: To enable a module, use the Drush command `drush en [module_name]`. Replace `[module_name]` with the machine name of your module.

4. **Disable a Module**: To disable a module, use the Drush command `drush pm-uninstall [module_name]`.

5. **Exit the Container**: Once you have enabled or disabled your modules, you can exit the container shell by typing `exit`.

### Using Drupal Admin Interface
You can also enable or disable modules directly from the Drupal admin interface:

1. **Access the Admin Panel**: Log into your Drupal site as an administrator.

2. **Navigate to Extend**: From the admin menu, navigate to `Manage` > `Extend`.

3. **Find Your Module**: Scroll through the list of modules or use the search functionality to find your custom module.

4. **Enable/Disable the Module**: 
   - To enable, check the box next to your module and click the `Install` button at the bottom of the page.
   - To disable, uncheck the box next to your module and click the `Uninstall` tab at the top of the page, then follow the prompts.

## Best Practices
- Always test new modules or changes to existing modules in a development environment before deploying to production.
- Keep documentation up-to-date for each custom module, including its purpose, configuration settings, and any dependencies.
- Ensure that custom modules are compliant with Drupal coding standards and best practices.

## Support
For assistance with custom modules or if you encounter any issues, please contact the development team.

Thank you for contributing to the APL-CMS project!
