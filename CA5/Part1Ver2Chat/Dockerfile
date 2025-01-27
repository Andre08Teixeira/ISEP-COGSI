# syntax=docker/dockerfile:1
FROM openjdk:17-jdk-slim

COPY ./basic_demo-0.1.0.jar /

CMD ["java", "-cp", "/basic_demo-0.1.0.jar", "basic_demo.ChatServerApp", "8080"]