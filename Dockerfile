# ===== Build stage =====
FROM maven:3.9.9-eclipse-temurin-21 AS build
WORKDIR /app

# Copy pom.xml and download dependencies (caching layer)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source and build
COPY src ./src
RUN mvn package -DskipTests

# ===== Runtime stage =====
FROM eclipse-temurin:21-jre
WORKDIR /app

# Copy built jar from build stage
COPY --from=build /app/target/sandbox-java-app-1.0-SNAPSHOT.jar app.jar

# Run the application
ENTRYPOINT ["java", "-cp", "app.jar", "com.sandbox.app.App"]