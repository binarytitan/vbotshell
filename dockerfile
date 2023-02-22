FROM ubuntu:latest

# Install required packages
RUN apt-get update && apt-get install -y \
    wget \
    unzip \
    lib32gcc1 \
    lib32stdc++6 \
    libcurl4-gnutls-dev \
    libtinfo5 \
    libtinfo-dev \
    libncurses5-dev \
    lib32z1 \
    libssl1.0.0 \
    libssl-dev \
    libssl1.0.0:i386 \
    libssl-dev:i386

# Download and install Valheim Manager
RUN wget https://github.com/mbround18/valheim-docker/raw/main/valheim-manager.zip && \
    unzip valheim-manager.zip -d /opt && \
    chmod +x /opt/valheim-manager/valheim.sh

# Expose port for Valheim Manager web interface
EXPOSE 8080

# Start Valheim Manager when container starts
CMD ["/opt/valheim-manager/valheim.sh"]
