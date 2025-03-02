#!/bin/bash

# Define repositories
JAVA_REPO="https://github.com/jenkins-docs/simple-java-maven-app.git"
NODE_REPO="https://github.com/Rdinesh1667/weather-app.git"

# Define directories
JAVA_DIR="simple-java-maven-app"
NODE_DIR="weather-app"

# Log file
LOG_FILE="build.log"

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to clone or pull a repository
clone_or_pull_repo() {
    local repo_url=$1
    local dir_name=$2

    if [ -d "$dir_name" ]; then
        echo "Pulling latest changes in $dir_name..."
        cd "$dir_name" || exit
        git pull origin master
        cd ..
    else
        echo "Cloning $dir_name..."
        git clone "$repo_url" "$dir_name"
    fi
}

# Function to check Java installation
check_java() {
    if ! command_exists java; then
        echo "Java is not installed. Please install Java and try again."
        exit 1
    fi
    echo "Java is installed."
}

# Function to check Node.js installation
check_node() {
    if ! command_exists node; then
        echo "Node.js is not installed. Please install Node.js and try again."
        exit 1
    fi
    echo "Node.js is installed."
}

# Function to build Java project
build_java() {
    echo "Building Java project..."
    cd "$JAVA_DIR" || exit
    mvn clean install >> "../$LOG_FILE" 2>&1
    if [ $? -eq 0 ]; then
        echo "Java project built successfully."
    else
        echo "Java project build failed. Check $LOG_FILE for details."
        exit 1
    fi
    cd ..
}

# Function to build Node.js project
build_node() {
    echo "Building Node.js project..."
    cd "$NODE_DIR" || exit
    npm install >> "../$LOG_FILE" 2>&1
    npm run build >> "../$LOG_FILE" 2>&1
    if [ $? -eq 0 ]; then
        echo "Node.js project built successfully."
    else
        echo "Node.js project build failed. Check $LOG_FILE for details."
        exit 1
    fi
    cd ..
}

# Main script
echo "Starting build process..."

# Clone or pull repositories
clone_or_pull_repo "$JAVA_REPO" "$JAVA_DIR"
clone_or_pull_repo "$NODE_REPO" "$NODE_DIR"

# Check for required tools
check_java
check_node

# Build projects
build_java
build_node

echo "Build process completed. Logs are saved in $LOG_FILE."