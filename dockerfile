FROM ghcr.io/quarto-dev/quarto:latest

# Install needed tools
RUN apt-get update && apt-get install -y \
    r-base r-cran-readr msmtp mutt \
    && rm -rf /var/lib/apt/lists/*

# Create workspace
WORKDIR /workspace
COPY . /workspace

RUN chmod +x /workspace/render_send.sh
