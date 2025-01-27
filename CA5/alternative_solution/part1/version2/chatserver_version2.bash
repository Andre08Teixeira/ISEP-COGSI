#!/bin/bash

container_name=$(buildah from docker.io/openjdk:17-jdk-slim)
buildah copy $container_name ./basic_demo-0.1.0.jar /

# Configurar o comando de inicialização dos container gerados a partir desta imagem
buildah config --cmd '["java", "-cp", "/basic_demo-0.1.0.jar", "basic_demo.ChatServerApp", "8080"]' $container_name

# Exportar a imagem para o repositório
image_name="chatserverjar:1.0"
buildah commit $container_name $image_name

buildah tag $image_name chatserverjar:latest