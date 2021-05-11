#!/usr/bin/env php

<?php

/**
 * Toggles Hardware Acceleration in all of the Thunderbird profiles of the given user.  Input value for
 * the fourth argument should either be 'ON' or 'OFF', referring to Hardware Acceleration.
 *
 * @author Aaron J <aaronj@econoprint.com>
 */

$user  = $argv[3];
$input = isset($argv[4]) ? strtoupper($argv[4]) : null;
$uProf = sprintf('/Users/%s/Library/Thunderbird/Profiles', $user);

// Normalize & Validate Input Value
switch ($input) {
  case 'ON':
    $value = 'false';
    break;
  case 'OFF':
    $value = 'true';
    break;
  case 'TRUE':
  case 'FALSE':
    echo 'For consistency, values of ON or OFF should be used, rather than true/false.';
    exit(1);
  case null:
  case '':
  default:
    echo 'The fourth argument is required.  Arguments 1-3 are provided by Jamf.';
    exit(1);
}

if (is_dir($uProf))
{
  foreach (glob($uProf.'/*/prefs.js') as $prefsFile)
  {
    echo 'Checking '.dirname($prefsFile)."\n";
    try
    {
      copy($prefsFile, sprintf('%s/prefs-%s.js.fix', dirname($prefsFile), date('Ymd')));

      $oData = file_get_contents($prefsFile);
      $nData = '';

      if (preg_match('#user_pref\("layers.acceleration.disabled", (true|false|1|0)\)#', $oData, $matches))
      {
        if ($matches[1] != $value)
        {
          echo '  Changing Value in '.$prefsFile."\n";
          $nLine = str_replace($matches[1], $value, $matches[0]);
          $nData = str_replace($matches[0], $nLine, $oData);
        }
      }
      else
      {
        echo '  Adding Value to '.$prefsFile."\n";
        $nData = $oData.sprintf("\nuser_pref(\"layers.acceleration.disabled\", %s)", $value);
      }
    }
    catch (\Exception $e)
    {
      echo '  ERROR: '.$e->getMessage();
      $nData = '';
    }

    if (!empty($nData))
    {
      file_put_contents($prefsFile, $nData);
    }
  }
}
else
{
  echo sprintf('No Thunderbird Profile for %s', $user);
  exit(1);
}

exit(0);
