FROM openjdk:17-jdk-slim


# Copiar apenas o jar da imagem de build
COPY ./nonrest.jar /nonrest/nonrest.jar

# Definir o diretório de trabalho
WORKDIR /nonrest

# Expor a porta da aplicação
EXPOSE 8000

# Comando para iniciar a aplicação
CMD ["java", "-jar", "nonrest.jar"]
