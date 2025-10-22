# Build-only image for the Java app (no DB)
# Adjust JDK version if your project needs a different Java version.

FROM maven:3.8-jdk-8 as builder
WORKDIR /build
COPY app/pom.xml . 
COPY app/src ./src
RUN mvn -B clean package -DskipTests

FROM openjdk:8-jre-slim
WORKDIR /app
# Copy the built jar (adjust path if your build produces a different name)
COPY --from=builder /build/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
