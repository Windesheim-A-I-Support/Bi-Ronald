FROM ghcr.io/quarto-dev/quarto:latest

# Install required packages
RUN apt-get update && apt-get install -y \
    r-base \
    r-cran-readr \
    msmtp \
    mutt \
    && rm -rf /var/lib/apt/lists/*

# Create working directory
WORKDIR /workspace

# Copy everything into container
COPY . /workspace

# Ensure the script is executable
RUN chmod +x /workspace/render_send.sh
