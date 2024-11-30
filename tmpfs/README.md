# Running FIO Benchmark with tmpfs in Docker

This guide explains how to run FIO (Flexible I/O Tester) benchmarks using tmpfs in a Docker container for memory performance testing.

## Build and Run Instructions

### 1. Build the Docker Image:

```bash
docker build -t fio-tmpfs-test .
```

### 2. Run Container with tmpfs Mount:

#### For Linux and MacOS:

```bash
docker run --rm \
  --mount type=tmpfs,destination=/mnt/tmpfs \
  fio-tmpfs-test
```

#### For Windows (cmd):

```cmd
docker run --rm -it --entrypoint=/bin/bash fio-tmpfs-test -c "/run_benchmark.sh"
```

## Technical Details

### Base Configuration

- Base Image: Ubuntu 22.04 LTS
- FIO Version: Latest stable release
- Mount Point: `/mnt/tmpfs` for tmpfs filesystem
- I/O Engine: Linux native asynchronous I/O (libaio)
- Direct I/O: Enabled (direct=1) to bypass OS cache

### Benchmark Tests

The benchmark suite runs three distinct tests to evaluate different aspects of memory performance:

1. Sequential Read (Q8T1)

   - Tests sequential read performance with queue depth 8
   - Measures maximum throughput capability
   - Simulates heavy sequential workloads

2. Sequential Read (Q1T1)

   - Tests sequential read performance with queue depth 1
   - Evaluates single-threaded sequential performance
   - Reflects typical application behavior

3. Random 4K Read (Q1T1)
   - Tests random read performance with 4KB blocks
   - Measures IOPS (Input/Output Operations Per Second)
   - Simulates database-like workloads

### Configurable Parameters

You can customize the benchmark by adjusting these parameters:

- `--size`: Test file size

  - Affects the amount of memory used
  - Should be set according to available system memory

- `--runtime`: Test duration

  - Controls how long each test runs
  - Longer runtime provides more stable results

- `--bs`: Block size

  - Defines the size of each I/O operation
  - Affects throughput and IOPS measurements

- `--iodepth`: Queue depth
  - Controls concurrent I/O operations
  - Higher values test maximum throughput capability

## Notes

- The test uses tmpfs to ensure pure memory performance testing
- Direct I/O bypass eliminates filesystem cache effects
- Results reflect raw memory and CPU performance
- Windows users need to use WSL2 for Docker operation
