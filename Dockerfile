# Stage 1: Build the application
FROM buildpack-deps:18-bullseye as builder
WORKDIR /build
COPY . .
RUN mvn -f app/pom.xml clean package -DskipTests

# Stage 2: Create the final, small image
FROM adoptopenjdk:11-jre-hotspot
WORKDIR /app

#
# THIS IS THE CORRECTED LINE:
# It now copies the "verademo-0.0.1-SNAPSHOT.jar" that your pom.xml builds.
#
COPY --from=builder /build/app/target/verademo-0.0.1-SNAPSHOT.jar /app/app.jar

EXPOSE 8080

# This entrypoint will now work because /app/app.jar exists
ENTRYPOINT ["java","-jar","/app/app.jar"]
