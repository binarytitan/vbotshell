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
    libssl-dev \
    libssl1.1 \
    libssl1.0-dev \
    libssl1.1:i386 \
    libssl1.0-dev:i386 \
    nodejs \
    npm && \
    rm -rf /var/lib/apt/lists/*

# Install Valheim Manager using npm
RUN npm install -g valheim-manager

# Expose port for Valheim Manager web interface
EXPOSE 8080

# Start Valheim Manager when container starts
CMD ["valheim-manager"]
