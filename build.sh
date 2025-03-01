#!/bin/bash

# Configuration
REPO_URL="https://github.com/peter-zizu/simple-java-maven-app.git"
REPO_DIR="simple-java-maven-app"
LOG_FILE="build.log"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Clone or update the repository
if [ -d "$REPO_DIR" ]; then
    echo "Repository already exists. Pulling latest changes..." | tee -a "$LOG_FILE"
    cd "$REPO_DIR" && git pull origin main | tee -a "../$LOG_FILE"
else
    echo "Cloning repository..." | tee -a "$LOG_FILE"
    git clone "$REPO_URL" | tee -a "$LOG_FILE"
    cd "$REPO_DIR"
fi

# Check if Java is installed
if command_exists java; then
    echo "Java is installed: $(java -version 2>&1 | head -n 1)" | tee -a "../$LOG_FILE"
else
    echo "Error: Java is not installed. Please install Java and try again." | tee -a "../$LOG_FILE"
    exit 1
fi

# Check if Maven is installed
if command_exists mvn; then
    echo "Maven is installed: $(mvn -version | head -n 1)" | tee -a "../$LOG_FILE"
else
    echo "Error: Maven is not installed. Please install Maven and try again." | tee -a "../$LOG_FILE"
    exit 1
fi

# Build the Java project with Maven
echo "Starting the build process..." | tee -a "../$LOG_FILE"
mvn clean install | tee -a "../$LOG_FILE"

if [ $? -eq 0 ]; then
    echo "Build successful!" | tee -a "../$LOG_FILE"
else
    echo "Build failed. Check the logs for details." | tee -a "../$LOG_FILE"
    exit 1
fi

exit 0
