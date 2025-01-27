package { 'git':
    ensure => 'installed',
}
package { 'openjdk-17-jdk':
    ensure => 'installed',
}
package { 'ufw':
    ensure => 'installed',
}
package { 'libpam-pwquality': 
  ensure => present,
}

file { '/etc/pam.d/common-password':
  ensure  => file,
  content => "password required pam_pwquality.so minlen=12 lcredit=-1ucredit=-1 dcredit=-1 ocredit=-1 retry=3 enforce_for_root",
  notify  => Exec['pam-configure'],
}

exec { 'pam-configure':
  command => '/usr/sbin/pam-auth-update',
  path    => ['/usr/sbin', '/usr/bin'],
  onlyif  => 'test -f /etc/pam.d/common-password',
}

group { 'developers':
  ensure => present,
}

user { 'devuser':
  ensure     => present,
  gid        => 'developers',
  home       => '/home/devuser',
  managehome => true,
  shell      => '/bin/bash',
}

user { 'vagrant':
  ensure     => present,
  gid        => 'developers',
}

exec { 'enable_ufw':
  command => 'ufw enable',
  path => ['/usr/sbin', '/bin', '/usr/bin'],
  onlyif  => 'ufw status | grep -q "Status: inactive"',
  require => Package['ufw'],
}

exec { 'allow_app_ip_on_db_port':
command => "ufw allow from 192.168.33.11 to any port 9092",
path => ['/usr/sbin'],
require => Exec['enable_ufw'],
}

exec { 'deny_db_port':
command => "ufw deny 9092",
path => ['/usr/sbin'],
require => Exec['allow_app_ip_on_db_port'],
}

exec { 'reload_ufw':
  command => 'ufw reload',
  path => ['/usr/sbin' ],
  require => Exec['deny_db_port'],
}

file { '/home/vagrant/.ssh':
  ensure => 'directory',
  owner  => 'vagrant',
  mode   => '0700',
}

exec { 'Add known hosts':
  command => 'ssh-keyscan -H github.com >> /home/vagrant/.ssh/known_hosts',
  user        => 'vagrant',
  environment => ['HOME=/home/vagrant'],
  path        => ['/usr/bin', '/usr/local/bin'],
  creates => '/home/vagrant/.ssh/known_hosts',
}

file { '/cogsi_project':
  ensure => 'directory',
  owner  => 'devuser',
  group  => 'developers',
  mode   => '0770',
}

vcsrepo { '/cogsi_project/cogsi2425-1181210-1190384-1181242':
  ensure   => present,
  provider => git,
  source   => 'git@github.com:1181210/cogsi2425-1181210-1190384-1181242.git',
  user     => 'vagrant'
}

file { '/shared':
  ensure => present,
  owner  => 'devuser',
  group  => 'developers',
  mode   => '0770',
  source => '/shared',
}
