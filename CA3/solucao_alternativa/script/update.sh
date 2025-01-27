#!/bin/bash

echo "<=============> A desativar os serviçso apt.daily.service e apt-daily-upgrade.service <=============>"

systemctl stop apt-daily.timer apt-daily-upgrade.timer
systemctl mask apt-daily.timer apt-daily-upgrade.timer
systemctl stop apt-daily.service apt-daily-upgrade.service
systemctl mask apt-daily.service apt-daily-upgrade.service
systemctl daemon-reload

# Instala os pacotes necessários
echo "<=============> A atualizar a lista de repositórios... <=============>"
apt-get -y update
if [[ $UPDATE =~ true || $UPDATE =~ 1 || $UPDATE =~ yes ]]; then
    apt-get -y dist-upgrade
fi
apt-get -y install --no-install-recommends build-essential linux-headers-generic
apt-get -y install --no-install-recommends ssh nfs-common vim curl git openjdk-17-jdk

echo "<=============> Remove o 'realease-upgrader' <=============>"
apt-get -y purge ubuntu-release-upgrader-core
rm -rf /var/lib/ubuntu-release-upgrader
rm -rf /var/lib/update-manager

# Limpa a cache do apt
apt-get -y autoremove --purge
apt-get -y clean

# Remove o timout do grub e a splash screen
sed -i -e '/^GRUB_TIMEOUT=/aGRUB_RECORDFAIL_TIMEOUT=0' \
    -e 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*/GRUB_CMDLINE_LINUX_DEFAULT="quiet nosplash"/' \
    /etc/default/grub
update-grub

# Alterações ao SSH
echo "UseDNS no" >> /etc/ssh/sshd_config

echo "${SSH_USERNAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$SSH_USERNAME

# Reinicia a máquina
echo "<==============>A desligar o serviço SSHD e a realizar o reboot da máquina...<==================>"
systemctl stop sshd.service
nohup shutdown -r now < /dev/null > /dev/null 2>&1 &
sleep 120
exit 0