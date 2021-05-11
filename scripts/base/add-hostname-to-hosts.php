#!/usr/bin/env php

<?php

/**
 * Adds hostname and fqdn to /etc/hosts, along with host.domain & localhost.domain for any given domain names.
 *
 * @param
 *
 * @author Aaron M Jones <aaronj@econoprint.com>
 */
const HOST_REGEX = '^(?:(?:[a-z\x{00a1}-\x{ffff}0-9]-*)*[a-z\x{00a1}-\x{ffff}0-9]+)(?:\.(?:[a-z\x{00a1}-\x{ffff}0-9]-*)*[a-z\x{00a1}-\x{ffff}0-9]+)*(?:\.(?:[a-z\x{00a1}-\x{ffff}]{2,}))$';

// Input Variables
$more = !empty($argv[4]) ? explode(',', $argv[4]) : null;

// Non Input Variables
$short = trim(shell_exec('hostname -s'));
$long  = trim(shell_exec('hostname -f'));
$file  = '/etc/hosts';

// No HostName Short Circuit
if ($short === $long || empty($long))
{
  echo 'Hostname Has Not Been Set.  Exiting...';
  exit(1);
}

// Invalid Hostname Short Circuit
if (!preg_match('#'.HOST_REGEX.'#iuS', $long))
{
  echo sprintf('Invalid Hostname: "%s". Exiting...', $long);
  exit(1);
}

// Get the Domain from the long hostname
$pattern = sprintf('#^%s.#', $short);
$domain  = preg_replace($pattern, '', $long, 1);
$domains = array_unique(array_merge([$domain], $more));

// Build Array to Add
$add = [$short, $long];
foreach ($domains as $suffix)
{
  foreach (['localhost', $short] as $prefix)
  {
    $entry = sprintf('%s.%s', $prefix, $suffix);
    if (!in_array($entry, $add))
    {
      $add[] = $entry;
    }
  }
}

// Get Contents of Hostsfile
if (file_exists($file))
{
  $out   = [];
  $hosts = file_get_contents($file);
  $lines = explode("\n", $hosts);
  foreach ($lines as $line)
  {
    $new = $line;
    if ('#' != substr($line, 0, 1))
    {
      if (preg_match('#^(127.0.0.1|::1)\s+(.*)$#', $line, $matches))
      {
        $ip = $matches[1];
        $hs = explode(' ', $matches[2]);

        if (in_array('localhost', $hs))
        {
          $new = $line.' '.implode(' ', array_diff($add, $hs));
        }
      }
    }

    $out[] = $new;
  }

  if (!empty($out))
  {
    file_put_contents($file, implode("\n", $out));
  }
}

exit(0);
