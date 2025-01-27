exec { 'run_gradle_module_task':
  command => '/cogsi_project/cogsi2425-1181210-1190384-1181242/CA2/tutRestGradle/gradlew :nonrest:startH2Server &', 
  cwd     => '/cogsi_project/cogsi2425-1181210-1190384-1181242/CA2/tutRestGradle', 
  user    => 'devuser',
  logoutput => true,
}
