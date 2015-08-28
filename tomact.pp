class tomcat::tomcat(
        $startport = hiera('tomcat::startport'),
        $shutdownport = hiera('tomcat::shutdownport'),
        $ajpport = hiera('tomcat::ajpport'),
        $sslport = hiera('tomcat::sslport'),
        $classpath = hiera('tomcat::classpath'),
        $xmx = hiera('tomcat::Xmx'),
){

$tomcat_id = "tomcat"
$app_name = "apache-tomcat-7.0.47.tar"
$fetch_url = "http://repo.wfxtriggers.com/artifactory/wfx-softwares/tomcat/${app_name}"
$install_path = "/usr/local/src/"
$full_path = "${install_path}/${app_name}"

	exec { "Download_${tomcat_id}":
		command => "curl -q --user deployment-release:deployment-release -o ${full_path} ${fetch_url}", 
    cwd => $install_path,
		path => '/usr/bin:/bin',
		creates => $full_path,
	  onlyif => "curl --HEAD --user deployment-release:deployment-release ${fetch_url} | grep 'HTTP/1.1 200 OK'",
	}		

 	exec {"extract_${tomcat_id}":
		command => "/bin/tar -xf ${full_path} -C /opt;mv /opt/apache-tomcat-7.0.47 /opt/${tomcat_id}; chown -R www:www /opt/${tomcat_id}",	
		cwd => $install_path,
		path => '/usr/bin:/bin',
		creates => "/opt/${tomcat_id}",
		require => Exec["Download_${tomcat_id}"]	
	}	

	file {"/etc/init.d/${tomcat_id}":
  	ensure => file,
  	owner => "root",
  	group => "root",
  	mode => 755,
    content => template("tomcat/tomcat.erb"),
  }

	file {"/opt/${tomcat_id}/bin/catalina.sh":
    ensure => file,
    owner => 'www',
    group => 'www',
    mode => 755,
		content => template("tomcat/catalina.sh.erb"),
  }

	file {"/opt/${tomcat_id}/conf/server.xml":
  	ensure => file,
  	owner => 'www',
  	group => 'www',
  	mode => 755,
		content => template("tomcat/server.xml.erb"),
  }
}