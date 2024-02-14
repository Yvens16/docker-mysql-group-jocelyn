
FROM eclipse-temurin:21-jdk AS base

WORKDIR /workspace/app
VOLUME /tmp

COPY mvnw .
COPY .mvn .mvn
COPY pom.xml .
COPY src src
RUN ./mvnw dependency:resolve

FROM base AS dev
CMD ["./mvnw", "spring-boot:run"]

FROM base AS test
CMD ["./mvnw", "test"]

# Production phase
FROM base AS build
RUN ./mvnw package

FROM eclipse-temurin:21-jre-jammy AS production
COPY --from=build /workspace/app/target/backend-0.0.1-SNAPSHOT.jar backend.jar
CMD ["java", "-jar", "/backend.jar"]