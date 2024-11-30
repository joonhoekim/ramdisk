#!/bin/bash
# run_benchmark.sh

# Create test directory
TEST_DIR="/mnt/tmpfs/test"
mkdir -p $TEST_DIR

# Sequential Read Q8T1
echo "Running Sequential Read Q8T1 Test..."
fio --name=seq_read_q8 \
    --directory=$TEST_DIR \
    --rw=read \
    --bs=1M \
    --size=1G \
    --numjobs=1 \
    --iodepth=8 \
    --runtime=10 \
    --time_based \
    --direct=1 \
    --ioengine=libaio \
    --group_reporting

# Sequential Read Q1T1
echo "Running Sequential Read Q1T1 Test..."
fio --name=seq_read_q1 \
    --directory=$TEST_DIR \
    --rw=read \
    --bs=1M \
    --size=1G \
    --numjobs=1 \
    --iodepth=1 \
    --runtime=10 \
    --time_based \
    --direct=1 \
    --ioengine=libaio \
    --group_reporting

# Random 4K Q1T1
echo "Running Random 4K Q1T1 Test..."
fio --name=rand_read_4k_q1 \
    --directory=$TEST_DIR \
    --rw=randread \
    --bs=4K \
    --size=1G \
    --numjobs=1 \
    --iodepth=1 \
    --runtime=10 \
    --time_based \
    --direct=1 \
    --ioengine=libaio \
    --group_reporting