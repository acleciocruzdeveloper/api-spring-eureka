FROM maven:3.9-amazoncorretto-17 as build
WORKDIR /app

COPY . .

RUN ["sh", "-c", "mvn clean package || true", "-X", "-e"]

FROM amazoncorretto:17-alpine

WORKDIR /app
COPY --from=build /app/target/*.jar app.jar

ARG USER_SECURITY=usuario-security
ARG PASSWORD_SECURITY=1234567890

EXPOSE 8761

ENTRYPOINT ["java", "-jar", "-Dspring.profiles.active-prod", "app.jar"]
