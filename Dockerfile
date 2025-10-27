# Build-only image for the Java app (no DB)
FROM maven:3.8-jdk-8 as builder
WORKDIR /build
# Copy the pom.xml and src code into the build environment
COPY app/pom.xml . 
COPY app/src ./src 
RUN mvn -B clean package -DskipTests

FROM openjdk:8-jre-slim
WORKDIR /app
# FINAL FIX: The JAR is verademo.war inside the 'target' folder. We need to copy it correctly.
# NOTE: The pom.xml you provided earlier has <packaging>jar</packaging>, so we assume the file name is correct.
COPY --from=builder /build/app/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
