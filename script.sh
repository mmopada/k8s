#!/bin/bash

# -------------------------
# Config
APP_JAR="C:\Users\sunka\Documents\Projects\kubernetes-final\target\finsights-app-0.0.1-SNAPSHOT.jar"          # path to your Spring Boot jar
APP_PORT=8086                       # desired port
CHECK_URL="http://localhost:$APP_PORT/hello"
# -------------------------

echo "1️⃣ Killing old Spring Boot processes..."
PIDS=$(ps -ef | grep java | grep "$APP_JAR" | awk '{print $2}')
if [ -n "$PIDS" ]; then
    echo "Found old processes: $PIDS"
    sudo kill $PIDS
    sleep 2
else
    echo "No old Spring Boot processes found."
fi

echo "2️⃣ Starting Spring Boot app on port $APP_PORT..."
nohup java -jar "$APP_JAR" --server.address=0.0.0.0 --server.port=$APP_PORT > app.log 2>&1 &

sleep 5  # wait for startup

echo "3️⃣ Verifying if app is listening..."
LISTENING=$(sudo lsof -i -P -n | grep ":$APP_PORT" | grep java)
if [ -n "$LISTENING" ]; then
    echo "✅ Spring Boot is running and listening on port $APP_PORT"
else
    echo "❌ App is not running. Check app.log for errors."
    exit 1
fi

echo "4️⃣ Testing /hello endpoint from WSL..."
curl $CHECK_URL
