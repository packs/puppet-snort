define snort::filters($ensure) {
  case $ensure {
    absent: {
      file { "/etc/snort/${name}":
        ensure => absent;
      }
    }
    present: {
      file {
        "/etc/snort/${name}":
          path   => "/etc/snort/${name}",
          source => ["puppet:///modules/snort/bpffiles/${name}-${::fqdn}",
                     "puppet:///modules/snort/bpffiles/${name}"],
          notify => Service['snortd'];
      }
    }
  }
}
