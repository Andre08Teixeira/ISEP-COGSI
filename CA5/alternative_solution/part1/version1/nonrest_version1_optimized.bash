#!/bin/bash

# Nome do container e das imagens
container_name="nonrest_optimized"
image_name="nonrest_optimized_buildah:1.0"

# Imagem base para o estágio de construção (build)
build_image="ubuntu:22.04"

# Estágio 1: Construção da aplicação (compilar código, clonar repositório, etc.)
buildah from --name ${container_name}-build $build_image

# Atualizar lista de pacotes e instalar ferramentas necessárias
buildah run ${container_name}-build apt-get update
buildah run ${container_name}-build apt-get install -y openssh-client git openjdk-17-jdk curl

# Criar o diretório .ssh para o usuário root e copiar a chave privada SSH
buildah run ${container_name}-build mkdir -p /root/.ssh
buildah copy ${container_name}-build ~/.ssh/id_ed25519 /root/.ssh/id_rsa

# Criar o arquivo de configuração do SSH para o GitHub
buildah run ${container_name}-build sh -c 'echo "Host github.com\n\tStrictHostKeyChecking no\n\tUserKnownHostsFile=/dev/null" > /root/.ssh/config'

# Definir permissões corretas para os arquivos SSH
buildah run ${container_name}-build chmod 700 /root/.ssh
buildah run ${container_name}-build chmod 600 /root/.ssh/id_rsa
buildah run ${container_name}-build chmod 600 /root/.ssh/config

# Clonar o repositório
repo_url="git@github.com:1181210/cogsi2425-1181210-1190384-1181242.git"
clone_path="/root/cogsi"
buildah run ${container_name}-build git clone $repo_url $clone_path

# Remover o arquivo application.properties (não necessário para esta iteração)
buildah run ${container_name}-build rm -rf /root/cogsi/CA2/tutRestGradle/nonrest/src/main/resources/application.properties

# Executar o Gradle para gerar o JAR
buildah run ${container_name}-build sh -c "cd /root/cogsi/CA2/tutRestGradle/nonrest && ../gradlew clean build"

# Estágio 2: Imagem final (executar a aplicação)
final_image="docker.io/openjdk:17-jdk-slim"

# Criar o container para o estágio final
buildah from --name ${container_name}-final $final_image

# Copiar o JAR gerado do estágio de construção para o estágio final
buildah copy --from=${container_name}-build ${container_name}-final /root/cogsi/CA2/tutRestGradle/nonrest/build/libs/nonrest.jar /nonrest.jar

# Definir o diretório de trabalho no estágio final
buildah config --workingdir / ${container_name}-final

# Expor a porta 8000 (para a documentação)
buildah config --port 8000 ${container_name}-final

# Configurar o comando de inicialização para o container gerado
buildah config --cmd '["java", "-jar", "/nonrest.jar"]' ${container_name}-final

# Exportar a imagem final
buildah commit ${container_name}-final $image_name

# Tag para a versão mais recente
buildah tag $image_name nonrest_optimized_buildah:latest

# Limpeza dos containers temporários
buildah rm ${container_name}-build
buildah rm ${container_name}-final