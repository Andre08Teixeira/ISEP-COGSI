#!/bin/bash

# Criar um novo container tendo por base uma imagem "Ubuntu"
container_name="nonrest"
base_image="ubuntu:22.04"
buildah from --name $container_name $base_image

# Atualizar a lista de pacotes e instalar as ferramentas necessárias
buildah run $container_name apt-get update
buildah run $container_name apt-get install -y openssh-client git openjdk-17-jdk curl

# Criar o diretório .ssh para o utilizador root
buildah run $container_name mkdir -p /root/.ssh

# Copiar a chave privada SSH para o Container
buildah copy $container_name ~/.ssh/id_ed25519 /root/.ssh/id_rsa

# Criar o ficheiro de configuração do SSH para o GitHub
buildah run $container_name sh -c 'echo "Host github.com\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile=/dev/null" > /root/.ssh/config'

# Definir as permissões corretas para os ficheiros SSH
buildah run $container_name chmod 700 /root/.ssh
buildah run $container_name chmod 600 /root/.ssh/id_rsa
buildah run $container_name chmod 600 /root/.ssh/config

# Clonar o repositório
repo_url="git@github.com:1181210/cogsi2425-1181210-1190384-1181242.git"
clone_path="/root/cogsi"
buildah run $container_name git clone $repo_url $clone_path

# Definir o diretório base como sendo a pasta nonrest
buildah config --workingdir /root/cogsi/CA2/tutRestGradle/nonrest $container_name

# Remover as application.properties (utilizadas para executar a base de dados num servidor - não é necessário para esta iteração)
buildah run $container_name rm -rf src/main/resources/application.properties

# Expor a porta 8000 - para documentação
buildah config --port 8000 $container_name

# Configurar o comando de inicialização dos container gerados a partir desta imagem
buildah config --cmd "../gradlew bootRun" $container_name

# Exportar a imagem para o repositório
image_name="nonrest_buildah:1.0"
buildah commit $container_name $image_name

buildah tag nonrest_buildah:1.0 nonrest_buildah:latest