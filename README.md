puppet-snort
============

Configuration templates for snort and daemonlogger.


Puppet Snort Module
=================

Module for configuring Snort.

Tested on RedHat Enterprise Linux 5.x and 6.x with Puppet 2.7. 
Patches for other operating systems are welcome.


Installation
------------

Clone this repo to a git directory under your Puppet modules directory:

    git clone https://github.com/packs/puppet-snort.git snort

Usage
-----

The `snort::sensor` class installs the snort application:

    include snort::sensor

The `snort::daemonlogger` class installs the packet logging system [daemonlogger][daemonlogger]:

    include snort::daemonlogger

By default `snort::sensor` assumes the rules files are managed as file resources by the Puppet Master.
If your sensor manages its own ruleset set the `$norules` option as in:

    'snort::sensor':
      ip_ranges => '[10.10.0.0/8]',
      norules => true;

Many other `snort.conf` options are configurable via parameters. Please see `sensor.pp` for full details.

[daemonlogger]: http://www.snort.org/snort-downloads/additional-downloads#daemonlogger
