<?php

namespace Drupal\hi_how_are_you\Commands;

use Drush\Commands\DrushCommands;

/**
 * A Drush command file.
 */
class HiHowAreYouCommands extends DrushCommands {

  /**
   * Creates a node.
   *
   * @command hi_how_are_you:create_node
   * @aliases hhay-cn
   */
  public function createNode() {
    hi_how_are_you_create_node();
    $this->logger()->success(dt('Node created successfully.'));
  }

}