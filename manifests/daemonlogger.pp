class snort::daemonlogger ( $interface = 'eth1', $capture_dir = '/data/capture_files', $filesize = '1073741824', $percent = '90' ){

  package {
    'daemonlogger':
      ensure => installed;
  }

  file {
    '/etc/sysconfig/daemonlogger':
      ensure  => present,
      content => template( 'snort/daemonlogger.erb'),
      alias   => 'daemonlogger-sysconfig',
      mode    => '0644',
      owner   => 'root',
      group   => 'root',
      notify  => Service['daemonlogger'],
      require => Package['daemonlogger'];
    '/etc/init.d/daemonlogger':
      ensure => present,
      source => 'puppet:///modules/snort/daemonlogger-init',
      alias  => 'daemonlogger-init',
      mode   => '0755',
      owner  => 'root',
      group  => 'root';
    "'${capture_dir}'":
      ensure => directory,
      mode   => '0644',
      owner  => 'root',
      group  => 'root',
      alias  => 'capture_dir';
  }

  service {
    'daemonlogger':
      ensure     => running,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
      require    => [ Package['daemonlogger'], File['daemonlogger-init'], File['daemonlogger-sysconfig'], File['capture_dir'] ];

  }

}

# vim modeline - have 'set modeline' and 'syntax on' in your ~/.vimrc.
# vi:syntax=puppet:filetype=puppet:ts=4:et:
