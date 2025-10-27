# Stage 1: Build the application
FROM buildpack-deps:18-bullseye as builder
WORKDIR /build
COPY . .
RUN mvn -f app/pom.xml clean package -DskipTests

# Stage 2: Create the final, small image
FROM adoptopenjdk:11-jre-hotspot
WORKDIR /app

#
# This is the line we are fixing.
# Your pom.xml builds "verademo-0.0.1-SNAPSHOT.jar".
#
COPY --from=builder /build/app/target/verademo-0.0.1-SNAPSHOT.jar /app/app.jar

EXPOSE 8080

# This entrypoint will now work because /app/app.jar exists
ENTRYPOINT ["java","-jar","/app/app.jar"]
