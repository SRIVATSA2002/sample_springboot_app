# Stage 1: Build the application
FROM maven:3.8.6-eclipse-temurin-17-alpine AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the pom.xml and download dependencies
COPY pom.xml ./
RUN mvn dependency:go-offline -B

# Copy the source code into the container
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Stage 2: Run the application
FROM eclipse-temurin:17-jre-alpine

# Set the working directory inside the container
WORKDIR /app

# Copy the JAR file from the previous stage
COPY --from=build /app/target/helloworld-0.0.1-SNAPSHOT.jar /app/helloworld.jar

# Expose the port on which the app will run
EXPOSE 8080

# Define the command to run the application
CMD ["java", "-jar", "/app/helloworld.jar"]
