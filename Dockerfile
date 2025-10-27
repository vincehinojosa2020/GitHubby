# Build-only image for the Java app (no DB)
FROM maven:3.8-jdk-8 as builder
WORKDIR /build
# Copy the pom.xml into the builder's root
COPY app/pom.xml . 
COPY app/src ./src 
RUN mvn -B clean package -DskipTests

FROM openjdk:8-jre-slim
WORKDIR /app
# FINAL FIX: Copy the built jar from where Maven leaves it 
# (it is in the /build/target/ directory, which is relative to the builder's root)
COPY --from=builder /build/target/*.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java","-jar","/app/app.jar"]
