#!/bin/bash

container_name=$(buildah from docker.io/openjdk:17-jdk-slim)
buildah copy $container_name ./nonrest.jar /

# Configurar o comando de inicialização dos container gerados a partir desta imagem
buildah config --cmd '["java", "-jar", "/nonrest.jar"]' $container_name

# Exportar a imagem para o repositório
image_name="nonrestjar:1.0"
buildah commit $container_name $image_name

buildah tag $image_name nonrestjar:latest