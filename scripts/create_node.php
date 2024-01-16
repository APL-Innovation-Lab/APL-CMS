<?php
// Drupal 9 script to create a node

use Drupal\node\Entity\Node;

$node = Node::create([
  'type' => 'page',
  'title' => 'My Title',
  'body' => [
    'value' => 'My Body',
    'format' => 'full_html',
  ],
]);

$node->save();
