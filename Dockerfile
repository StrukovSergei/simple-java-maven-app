# Use a Maven base image for building the application
FROM maven:3.8.7-openjdk-18-slim AS build

# Set the working directory in the container
WORKDIR /app

# Copy the project files into the container
COPY pom.xml .
COPY src/ ./src/

# Build the project using Maven
RUN mvn clean package

# Set the version using the build argument
ARG VERSION
RUN mvn -B versions:set -DnewVersion=${VERSION} -DgenerateBackupPoms=false

# List the contents of the target directory for debugging
RUN ls -l /app/target

# Use an OpenJDK image as the final image for running the application
FROM openjdk:11-jre-slim

# Set the working directory in the container
WORKDIR /app

# Create a new user and group
RUN addgroup --system appgroup && adduser --system --ingroup appgroup appuser

# Copy the built JAR file from the previous image to the final image
COPY --from=build /app/target/*.jar /app/your-app.jar

# Change ownership of the app directory to the new user
RUN chown -R appuser:appgroup /app

# Expose the ports your application uses (if any)
# Example: Expose port 8080
EXPOSE 8080

# Switch to the new user
USER appuser

# Run the application
# Replace 'your-app.jar' with the name of the JAR file that Maven builds
CMD ["java", "-jar", "your-app.jar"]
