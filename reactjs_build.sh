#!/bin/bash

# Variables
REPO_URL="https://github.com/peter-zizu/weatherApp-Reactjs.git"  # Change to your repo URL
PROJECT_NAME="weatherApp-Reactjs"
LOG_FILE="build.log"

# Function to log messages
log() {
    echo "$(date +"%Y-%m-%d %T") - $1" | tee -a "$LOG_FILE"
}

# Step 1: Clone or pull the latest changes
if [ -d "$PROJECT_NAME" ]; then
    log "Repository already exists. Pulling latest changes..."
    cd "$PROJECT_NAME" || exit
    git pull origin main 2>&1 | tee -a ../"$LOG_FILE"
else
    log "Cloning repository..."
    git clone "$REPO_URL" "$PROJECT_NAME" 2>&1 | tee -a "$LOG_FILE"
    cd "$PROJECT_NAME" || exit
fi

# Step 2: Check if Node.js is installed
if ! command -v node &> /dev/null; then
    log "Node.js is not installed. Please install it and re-run the script."
    exit 1
else
    log "Node.js is installed."
fi

# Step 3: Install dependencies and build the project
log "Installing dependencies..."
npm install 2>&1 | tee -a ../"$LOG_FILE"

log "Building the project..."
npm run build 2>&1 | tee -a ../"$LOG_FILE"

log "Build process completed successfully."


