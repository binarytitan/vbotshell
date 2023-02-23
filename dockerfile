FROM ubuntu:latest

# Update package list and install required packages
RUN apt-get update && \
    apt-get install -y apt-utils && \
    apt-get install -y --no-install-recommends nodejs && \
    apt-get install -y npm && \
    apt-get install -y ttyd && \
    apt-get install -y lib32gcc-s1 && \
    rm -rf /var/lib/apt/lists/*

# Set environment variables for config values
ENV CONFIG_LOCATION="./vmconfig.json"
ENV SERVER_LOCATION="./server"
ENV BACKUP_FREQUENCY=100
ENV BACKUP_RETENTION=100
ENV AUTO_OPEN_PORTS=false
ENV AUTO_RESTART_SERVER=true
ENV LAUNCHER_PORT=2456
ENV LAUNCHER_WORLD="TitanDedicated"
ENV LAUNCHER_NAME="Titan_Server_2.0"
ENV LAUNCHER_PASSWORD="supersecret"
ENV DISCORD_SERVER_ID="393128513122861056"
ENV DISCORD_ADMIN_ROLE_ID="398571211518640128"
ENV DISCORD_SERVER_LOG_CHANNEL="1076336628718653440"
ENV DISCORD_COMMAND_LOG_CHANNEL="1076336628718653440"
ENV LOG_DEBUG=false
ENV LOG_DETAIL=false
ENV LOG_GENERAL=true
ENV LOG_WARNING=true
ENV LOG_ERROR=true
ENV LOG_PREFIX="ValheimManager -"
ENV WRITE_LOG=true
ENV LOG_FILE_NAME="ManagerLog.txt"
ENV LOG_FILE_PATH="./logs"
ENV LOG_FILE_SIZE="100M"
ENV LOG_FILE_AGE=7
ENV LOG_FILE_COUNT=4
RUN if [ -f "/keyfile.txt" ]; then \
    echo "keyfile.txt file exists, setting DISCORD_TOKEN."; \
    export DISCORD_TOKEN=$(cat /tmp/keyfile.json | jq -r '.DISCORD_TOKEN'); \
    else \
    echo "keyfile.txt file DOES NOT exists, setting DISCORD_TOKEN to nothing."; \
    export DISCORD_TOKEN=""; \
    fi
ENV DISCORD_TOKEN=$DISCORD_TOKEN

#generate vmconfig.json
RUN echo '{ \
            "manager": { \
              "configLocation": "'"$CONFIG_LOCATION"'", \
              "serverLocation": "'"$SERVER_LOCATION"'", \
              "backupFrequency": '"$BACKUP_FREQUENCY"', \
              "backupRetention": '"$BACKUP_RETENTION"', \
              "autoOpenPorts": '"$AUTO_OPEN_PORTS"', \
              "autoRestartServer": '"$AUTO_RESTART_SERVER"' \
            }, \
            "launcher": { \
              "port": '"$LAUNCHER_PORT"', \
              "world": "'"$LAUNCHER_WORLD"'", \
              "name": "'"$LAUNCHER_NAME"'", \
              "password": "'"$LAUNCHER_PASSWORD"'" \
            }, \
            "discord": { \
              "token": "'"$DISCORD_TOKEN"'", \
              "serverId": "'"$DISCORD_SERVER_ID"'", \
              "adminRoleId": "'"$DISCORD_ADMIN_ROLE_ID"'", \
              "serverLogChannel": "'"$DISCORD_SERVER_LOG_CHANNEL"'", \
              "commandLogChannel": "'"$DISCORD_COMMAND_LOG_CHANNEL"'" \
            }, \
            "logging": { \
              "logDebug": '"$LOG_DEBUG"', \
              "logDetail": '"$LOG_DETAIL"', \
              "logGeneral": '"$LOG_GENERAL"', \
              "logWarning": '"$LOG_WARNING"', \
              "logError": '"$LOG_ERROR"', \
              "prefix": "'"$LOG_PREFIX"'", \
              "writeLog": '"$WRITE_LOG"', \
              "fileName": "'"$LOG_FILE_NAME"'", \
              "filePath": "'"$LOG_FILE_PATH"'", \
              "fileSize": "'"$LOG_FILE_SIZE"'", \
              "fileAge": '"$LOG_FILE_AGE"', \
              "fileCount": '"$LOG_FILE_COUNT"' \
            } \
        }' > /vmconfig.json;


# Install Valheim Manager
npm install -g valheim-manager;

# Expose port for Valheim Manager web interface
EXPOSE 8080

COPY /index.js /usr/local/lib/node_modules/valheim-manager/index.js

# Start ttyd to enable terminal access through the browser
CMD ["ttyd", "-p", "8080", "/bin/bash"]
