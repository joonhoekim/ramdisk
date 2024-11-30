#!/bin/bash

# chmod +x ramdisk_benchmark.sh
# sudo ./ramdisk_benchmark.sh

# RAM Disk 크기 설정 (10GB = 20971520)
RAMDISK_SECTORS=20971520
# 테스트 파일 크기 (1GB)
TEST_SIZE=1073741824
# 블록 크기 (1MB)
BLOCK_SIZE=1048576

# 클러스터 사이즈 배열 (바이트 단위)
CLUSTER_SIZES=(4096 8192 16384 32768 65536)

# 결과를 저장할 파일
RESULTS_FILE="ramdisk_benchmark_results.txt"

# 결과 파일 초기화
echo "RAM Disk Benchmark Results" > $RESULTS_FILE
echo "=========================" >> $RESULTS_FILE
date >> $RESULTS_FILE
echo "" >> $RESULTS_FILE

run_benchmark() {
    local mount_point="/Volumes/RAM Disk"
    echo "Running benchmark..."
    
    # 순차 쓰기 테스트
    echo "Sequential Write Test..."
    dd if=/dev/zero of="$mount_point/test_file" bs=$BLOCK_SIZE count=$((TEST_SIZE/BLOCK_SIZE)) 2>&1 | grep "bytes" >> $RESULTS_FILE
    
    # 캐시 정리
    sudo purge
    
    # 순차 읽기 테스트
    echo "Sequential Read Test..."
    dd if="$mount_point/test_file" of=/dev/null bs=$BLOCK_SIZE 2>&1 | grep "bytes" >> $RESULTS_FILE
    
    # 랜덤 읽기/쓰기 테스트 (4K)
    echo "Random 4K Write Test..."
    dd if=/dev/zero of="$mount_point/random_test" bs=4096 count=262144 oflag=direct 2>&1 | grep "bytes" >> $RESULTS_FILE
    
    echo "Random 4K Read Test..."
    dd if="$mount_point/random_test" of=/dev/null bs=4096 count=262144 iflag=direct 2>&1 | grep "bytes" >> $RESULTS_FILE
    
    # 테스트 파일 정리
    rm "$mount_point/test_file" "$mount_point/random_test"
}

create_ramdisk_exfat() {
    local cluster_size=$1
    echo "Creating RAM Disk with exFAT - Cluster size: ${cluster_size} bytes"
    echo "exFAT - Cluster size: ${cluster_size} bytes" >> $RESULTS_FILE
    
    # 기존 RAM Disk 제거
    diskutil list | grep "RAM Disk" > /dev/null && diskutil eject "RAM Disk"
    
    # 새 RAM Disk 생성 및 포맷
    diskutil erasevolume ExFAT "RAM Disk" `hdiutil attach -nomount ram://${RAMDISK_SECTORS}` -c ${cluster_size}
    
    # 벤치마크 실행
    run_benchmark
    
    echo "" >> $RESULTS_FILE
    diskutil eject "RAM Disk"
}

create_ramdisk_apfs() {
    echo "Creating RAM Disk with APFS"
    echo "APFS Test" >> $RESULTS_FILE
    
    # 기존 RAM Disk 제거
    diskutil list | grep "RAM Disk" > /dev/null && diskutil eject "RAM Disk"
    
    # APFS RAM Disk 생성
    diskutil erasevolume APFS "RAM Disk" `hdiutil attach -nomount ram://${RAMDISK_SECTORS}`
    
    # 벤치마크 실행
    run_benchmark
    
    echo "" >> $RESULTS_FILE
    diskutil eject "RAM Disk"
}

echo "Starting benchmark tests..."

echo "Testing exFAT with different cluster sizes..."
for size in "${CLUSTER_SIZES[@]}"; do
    create_ramdisk_exfat $size
done

echo "Testing APFS..."
create_ramdisk_apfs

echo "All tests completed. Results saved in $RESULTS_FILE"