# Stage 1: Build the application
# Use the official Maven 3 image with Temurin (Java 11)
FROM maven:3-eclipse-temurin-11 AS builder
WORKDIR /build
COPY . .
# Run the Maven build
RUN mvn -f app/pom.xml clean package -DskipTests

# Stage 2: Create the final, small image
# Use the modern, supported Eclipse Temurin JRE 11
FROM eclipse-temurin:11-jre
WORKDIR /app

#
# This is the corrected COPY line from our last discussion.
# It copies the "verademo-0.0.1-SNAPSHOT.jar" that pom.xml builds.
#
COPY --from=builder /build/app/target/verademo-0.0.1-SNAPSHOT.jar /app/app.jar

EXPOSE 8080

# This entrypoint will now work because /app/app.jar exists
ENTRYPOINT ["java","-jar","/app/app.jar"]
