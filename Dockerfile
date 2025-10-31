
# Step 1: Build stage
FROM maven:3.9.6-eclipse-temurin-17 AS build
WORKDIR /app

# Copy Maven files first for dependency caching
COPY pom.xml ./
COPY src ./src

# Build the application
RUN mvn clean package -DskipTests

# Step 2: Run stage
FROM eclipse-temurin:17-jdk
WORKDIR /app

COPY --from=build /app/target/*.jar app.jar
EXPOSE 8084
EXPOSE 8086
ENTRYPOINT ["java", "-jar", "app.jar"]
