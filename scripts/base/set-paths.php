#!/usr/bin/env php

<?php
/**
 * Adds /usr/local/sbin & /usr/local/bin to the system-wide paths if needed, eliminating any duplicats.
 * @author Aaron M Jones <aaronj@econoprint.com>
 */

// Set Variables
$pathFile   = '/etc/paths';
$newPaths   = ['/usr/local/sbin', '/usr/local/bin'];
$finalPaths = [];

// Exit if Paths File Doesn't Exists
if (!is_file($pathFile))
{
  echo sprintf('ERROR: %s does not exist! Exiting...', $pathFile);
  exit(1);
}

// Read the Existing Content
$data  = file_get_contents($pathFile);
$lines = explode("\n", $data);

// Only Add Existing Paths, Unique Entries
foreach ($newPaths as $newPath)
{
  $newPath = rtrim($newPath, '/');
  if (is_dir($newPath) && !in_array($newPath, $finalPaths))
  {
    if (!in_array($newPath, $lines))
    {
      echo sprintf("Adding %s...\n", $newPath);
    }
    $finalPaths[] = $newPath;
  }
}

// Eliminate Duplicates
if (!empty($finalPaths))
{
  $diff = array_diff($lines, $finalPaths);

  // Add Existing Paths to Array
  $finalPaths = array_merge($finalPaths, $diff);

  if (false === @file_put_contents($pathFile, implode("\n", $finalPaths)))
  {
    echo sprintf("ERROR: Could not write to '%s'.  Exiting...", $pathFile);
    exit(1);
  }
}
else
{
  echo 'No Paths to Add! Exiting...';
}

exit(0);
