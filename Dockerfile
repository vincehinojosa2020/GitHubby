# Build-only image for the Java app (no DB)
# If your project needs a different Java version adjust this.

FROM maven:3.8-jdk-8 AS builder
WORKDIR /build
# Copy files needed for build
COPY pom.xml .
COPY src ./src
RUN mvn -B clean package -DskipTests

FROM openjdk:8-jre-slim
WORKDIR /app
COPY --from=builder /build/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
