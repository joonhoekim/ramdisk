# Storage Performance Analysis Report

November 30, 2024

## Executive Summary

This report analyzes FIO benchmark results across four different system configurations, comparing their storage performance characteristics. The tests include sequential read operations with different queue depths (Q8T1 and Q1T1) and random 4K reads (Q1T1).

## Test Configurations

1. Apple M1 Max (64GB) - tmpfs with Docker container
2. Intel i7-12700H (16GB 3733MT/s) - tmpfs with Docker container
3. Intel i7-12700H (16GB 3733MT/s) - ImDisk with mmap engine
4. Intel i7-12700H (16GB 3733MT/s) - ImDisk with windowsaio engine

## Performance Results

### Sequential Read Q8T1 (1024KiB Block Size)

| System Configuration       | Bandwidth | IOPS | Average Latency |
| -------------------------- | --------- | ---- | --------------- |
| M1 Max (tmpfs)             | 7831 MB/s | 7831 | 1.02 ms         |
| 12700H (tmpfs)             | 3372 MB/s | 3216 | 2.49 ms         |
| 12700H (imdisk mmap)       | 4259 MB/s | 4061 | 0.25 ms         |
| 12700H (imdisk windowsaio) | 5886 MB/s | 5613 | 0.89 ms         |

### Sequential Read Q1T1 (1024KiB Block Size)

| System Configuration       | Bandwidth | IOPS  | Average Latency |
| -------------------------- | --------- | ----- | --------------- |
| M1 Max (tmpfs)             | 26.1 GB/s | 24.9K | 0.04 ms         |
| 12700H (tmpfs)             | 2.13 GB/s | 2029  | 0.49 ms         |
| 12700H (imdisk mmap)       | 4.32 GB/s | 4120  | 0.24 ms         |
| 12700H (imdisk windowsaio) | 5.67 GB/s | 5407  | 0.18 ms         |

### Random Read 4K Q1T1

| System Configuration       | IOPS  | Bandwidth | Average Latency |
| -------------------------- | ----- | --------- | --------------- |
| M1 Max (tmpfs)             | 647K  | 2527 MB/s | 1.38 μs         |
| 12700H (tmpfs)             | 10.2K | 39.7 MB/s | 98.02 μs        |
| 12700H (imdisk mmap)       | 1826K | 7131 MB/s | 0.43 μs         |
| 12700H (imdisk windowsaio) | 77.2K | 302 MB/s  | 12.56 μs        |

## Key Findings

1. **M1 Max Performance**

   - Demonstrates superior performance in sequential Q1T1 operations
   - Shows excellent 4K random read performance with high IOPS
   - Maintains consistent low latency across different test scenarios

2. **Windows Implementation Comparison**

   - mmap engine shows better random 4K performance than windowsaio
   - windowsaio provides better sequential read performance
   - tmpfs with Docker container shows generally lower performance compared to native implementations

3. **I/O Engine Impact**

   - mmap engine excels in random 4K operations
   - windowsaio shows better sequential read performance
   - Docker container virtualization appears to introduce significant overhead

4. **Latency Characteristics**
   - mmap engine consistently shows lower latency across all tests
   - Docker container implementation shows higher latency compared to native implementations
   - M1 Max maintains very low latency despite high throughput

## Recommendations

1. For Windows systems:

   - Use mmap engine for workloads with many small random reads
   - Consider windowsaio for sequential read-heavy workloads
   - Avoid Docker container for performance-critical ramdisk operations

2. For optimal performance:
   - M1 Max platform shows superior overall performance
   - Native implementations (mmap, windowsaio) perform better than containerized solutions
   - Consider workload characteristics when choosing between mmap and windowsaio engines

## Conclusion

The analysis reveals significant performance variations across different implementations and platforms. The M1 Max shows exceptional performance characteristics, while on Windows systems, the choice of I/O engine significantly impacts performance. Native implementations consistently outperform containerized solutions, suggesting that Docker containers may not be optimal for high-performance ramdisk operations.
