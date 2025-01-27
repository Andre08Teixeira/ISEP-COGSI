exec { 'wait_for_db_vm':
  command   => '/bin/bash -c "while ! /usr/bin/nc -z 192.168.33.11 9092; do sleep 5; done;"',
  user      => 'devuser',
  logoutput => true,
  unless    => '/usr/bin/nc -z 192.168.33.11 9092',
}


exec { 'run_gradle_task':
  command   => '/cogsi_project/cogsi2425-1181210-1190384-1181242/CA2/tutRestGradle/gradlew :nonrest:bootRun &',
  cwd       => '/cogsi_project/cogsi2425-1181210-1190384-1181242/CA2/tutRestGradle',
  user      => 'devuser',
  logoutput => true,
  onlyif     => '/bin/bash -c \"! netstat -tuln | grep \":8080\"\"',
  require   => Exec['wait_for_db_vm'],
}
