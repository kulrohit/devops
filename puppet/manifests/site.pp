node default {
  include os
  include ntp
  include apache


user { 'apache':
  ensure     => present,
  uid        => '1080',
  gid        => '1080',
#  shell      => '/bin/nologin',
}

group { 'apache':
	ensure => present,
	gid	  => 1080,
	}




}
