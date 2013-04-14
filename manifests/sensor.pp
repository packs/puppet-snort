class snort::sensor ( $ip_ranges ='any' , $dns_servers = '$HOME_NET', $snort_perfprofile = false, $stream_memcap = '8388608', $stream_prune_log_max = '1048576', $stream_max_queued_segs = '2621', $stream_max_queued_bytes = '1048576', $perfmonitor_pktcnt = '10000', $dcerpc2_memcap = '102400', $enable = true, $ensure = running, $barnyard = false, $norules = false, $rotation = '7' ) {

  package {
    'snort':
      ensure => installed;
    'daq':
      ensure => installed;
    'barnyard2':
      ensure  => $barnyard ? {
        true    => installed,
        default => absent,
      },
      require => Package['snort'];
  }

  if $norules == true {
    file {
      '/etc/snort/rules':
        ensure  => directory,
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        require => Package[snort];
    }
  }
  else {
    file {
      '/etc/snort/rules':
        ensure  => directory,
        source  => 'puppet:///modules/snort/rules',
        purge   => true,
        ignore  => '.svn',
        recurse => true,
        force   => true,
        mode    => '0644',
        owner   => 'root',
        group   => 'root',
        notify  => [ Service['snortd'], Service['barnyard2'] ],
        require => Package['snort'];
    }
  }

  file {
    '/etc/snort/rules/local.rules':
      ensure  => present,
      source  => [ "puppet:///modules/snort/local/local.rules-${::fqdn}",
                  'puppet:///modules/snort/local/local.rules' ],
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      force   => true,
      notify  => Service['snortd'],
      require => Package['snort'];
    '/etc/snort/snort.conf':
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      alias   => 'snortconf',
      content => template( 'snort/snort.conf.erb'),
      notify  => Service['snortd'],
      require => Package['snort'];
    '/etc/sysconfig/snort':
      source  => [ "puppet:///modules/snort/sysconfig/snort-${::fqdn}",
                  'puppet:///modules/snort/sysconfig/snort' ],
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      notify  => Service['snortd'],
      require => Package['snort'];
    '/etc/logrotate.d/snort':
      content => template( 'snort/snort.rotate.erb'),
      mode    => '0644',
      owner   => 'root',
      group   => 'root';
    '/etc/cron.d/snort-clean' :
      source => 'puppet:///modules/snort/snortcleanup.cron',
      mode   => '0440',
      owner  => 'root',
      group  => 'root';
    '/usr/local/sbin/snortcleanup.sh' :
      source => 'puppet:///modules/snort/snortcleanup.sh',
      mode   => '0550',
      owner  => 'root',
      group  => 'root';
    '/etc/snort/barnyard2.conf' :
      ensure  => $barnyard ? {
        true    => present,
        default => absent,
      },
      content => template( 'snort/barnyard2.conf.erb'),
      mode    => '0550',
      owner   => 'root',
      group   => 'root',
      notify  => Service['barnyard2'],
      require => Package['barnyard2'];
    '/etc/sysconfig/barnyard2' :
      ensure  => $barnyard ? {
        true    => present,
        default => absent,
      },
      source  => [ "puppet:///modules/snort/sysconfig/barnyard2-${::fqdn}",
                  'puppet:///modules/snort/sysconfig/barnyard2' ],
      mode    => 0550,
      owner   => 'root',
      group   => 'root',
      notify  => Service['barnyard2'],
      require => Package['barnyard2'];
    '/etc/snort/barnyard2.waldo' :
      ensure  => $barnyard ? {
        true    => file,
        default => absent,
      },
      mode    => '0550',
      owner   => 'root',
      group   => 'root',
      notify  => Service[barnyard2],
      require => Package[barnyard2];
    '/var/log/snort/archive' :
      ensure => $barnyard ? {
        true    => directory,
        default => absent,
      };
      mode   => '0660',
      owner  => 'snort',
      group  => 'snort',
  }


  service {
    'snortd':
      ensure     => $ensure,
      enable     => $enable,
      hasstatus  => true,
      hasrestart => true,
      require    => Package['snort'];
    'barnyard2':
      ensure     => $barnyard ? {
        true    => running,
        default => stopped,
      },
      enable     => $barnyard2,
      hasstatus  => true,
      hasrestart => true,
      require    => Package['barnyard2'];
  }
}

# vim modeline - have 'set modeline' and 'syntax on' in your ~/.vimrc.
# vi:syntax=puppet:filetype=puppet:ts=4:et:
