class apache {
exec { 'apt-update':                    # exec resource named 'apt-update'
  command => '/usr/bin/apt-get update'  # command this resource will run
}

# install apache2 package
package { 'apache2':
  require => Exec['apt-update'],        # require 'apt-update' before installing
  ensure => installed,
}

# ensure apache2 service is running
service { 'apache2':
  ensure => running,
}
#    file { 'apache2.conf':
 #   path    => '/etc/apache2/apache2.conf',
  #  recurse => true,
  #  ensure  => file,
  #  require => Package['apache2'],
  #  source  => 'puppet:///modules/apache2/httpd.conf',
#		owner   => 'apache',
#    group   => 'apache',
 #   }

#	file { 'index.html':
#    path    => '/var/www/html/index.html',
#    recurse => true,
#    ensure  => file,
#    require => Package['apache2'],
#    source  => 'puppet:///modules/apache/index.html',
#		owner   => 'apache',
#    group   => 'apache',
#  }
#	file { "/etc/apache2":
#		ensure	=> directory,
##    require => Package['apache2'],
#    recurse => true, 
#  	owner		=> "apache",
#  	group		=> "apache",
#	 }
}
