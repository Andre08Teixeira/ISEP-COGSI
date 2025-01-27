# syntax=docker/dockerfile:1
FROM ubuntu:22.04 as builder

# Instalar as dependências
RUN apt-get update && apt-get install -y git curl vim openjdk-17-jdk && rm -rf /var/lib/apt/lists/*

# Criar uma pasta .ssh na home do utilizador root
RUN mkdir /root/.ssh && chmod -R 700 /root/.ssh

# Copiar a chave privada da pasta .ssh do host para a imagem
COPY id_ed25519 /root/.ssh/id_ed25519

# Alteração de permissões e configurações do ssh
RUN chmod 0400 /root/.ssh/id_ed25519 && echo "StrictHostKeyChecking no" > /root/.ssh/config

# Adicionar o github aos 'known_hosts'
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts

RUN eval "$(ssh-agent -s)" && ssh-add /root/.ssh/id_ed25519

WORKDIR /build
# Realizar o clone do repositório
RUN git clone git@github.com:1181210/cogsi2425-1181210-1190384-1181242.git cogsi
WORKDIR /build/cogsi/CA2/gradle_basic_demo-main

# Construir o projeto usando o Gradle e gerar o JAR
RUN ./gradlew clean build

# Stage 2: Ambiente runtime
FROM openjdk:17-jdk-slim

# Copiar apenas o jar da imagem de build
COPY --from=builder /build/cogsi/CA2/gradle_basic_demo-main/build/libs/basic_demo-0.1.0.jar /gradle_basic_demo-main/basic_demo-0.1.0.jar

# Definir o diretório de trabalho
WORKDIR /gradle_basic_demo-main

# Expor a porta da aplicação
EXPOSE 59001

# Comando para iniciar a aplicação
CMD '["java", "-cp", "/gradle_basic_demo-main/basic_demo-0.1.0.jar", "basic_demo.ChatServerApp", "59001"]'

