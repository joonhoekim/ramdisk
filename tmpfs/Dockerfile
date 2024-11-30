# Dockerfile
FROM ubuntu:22.04

# Install required packages
RUN apt-get update && \
    apt-get install -y fio && \
    rm -rf /var/lib/apt/lists/*

# Create mount point for tmpfs
RUN mkdir /mnt/tmpfs

# Copy benchmark script
COPY run_benchmark.sh /
RUN sed -i 's/\r$//' run_benchmark.sh
RUN chmod +x /run_benchmark.sh

ENTRYPOINT ["/run_benchmark.sh"]