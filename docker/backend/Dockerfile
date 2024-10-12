FROM maven:3.9.8-eclipse-temurin-21 AS build
WORKDIR /build

COPY pom.xml .
RUN mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

FROM openjdk:21
WORKDIR /app

COPY --from=build /build/target/*.jar /app/app.jar

ENV APP_VERSION=${JAR_VERSION}
ENV SPRING_PORT=${SPRING_PORT}
ENV SPRING_DB_URL=${SPRING_DB_URL}
ENV SPRING_JAVA_OPTS=${JAVA_OPTS}

CMD sh -c 'java ${SPRING_JAVA_OPTS:+$SPRING_JAVA_OPTS }-jar -Dspring.datasource.url=${SPRING_DB_URL} -Dserver.port=${SPRING_PORT} /app/app.jar'