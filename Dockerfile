FROM maven:3.9-amazoncorretto-17 as build
WORKDIR /app

# Copiar o pom.xml e baixar as dependências primeiro (cache)
COPY pom.xml ./
RUN mvn dependency:go-offline -B

COPY . .

RUN mvn clean package

FROM amazoncorretto:17-alpine

WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

ARG USER_SECURITY=usuario-security
ARG PASSWORD_SECURITY=1234567890

EXPOSE 8761

ENTRYPOINT ["java", "-jar", "-Dspring.profiles.active=prod", "app.jar"]
