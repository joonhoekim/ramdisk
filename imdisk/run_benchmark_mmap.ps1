# run_benchmark.ps1

# Test directory and file setup with absolute path
$TEST_DIR = "R:\test"
$TEST_FILE = "R:\test\fio_test"

# Create directory if it doesn't exist
if (!(Test-Path -Path $TEST_DIR)) {
    Write-Host "Creating test directory at $TEST_DIR"
    New-Item -ItemType Directory -Force -Path $TEST_DIR
}

# Create a small test file to ensure the path works
Write-Host "Creating test file at $TEST_FILE"
fsutil file createnew $TEST_FILE (1GB)

Write-Host "Starting FIO benchmarks..."

# Sequential Read Q8T1
Write-Host "`nRunning Sequential Read Q8T1 Test..."
& fio --name=seq_read_q8 `
    --filename="$TEST_FILE" `
    --rw=read `
    --bs=1M `
    --size=1G `
    --numjobs=1 `
    --iodepth=8 `
    --runtime=10 `
    --time_based `
    --thread `
    --ioengine=mmap `
    --group_reporting

# Sequential Read Q1T1
Write-Host "`nRunning Sequential Read Q1T1 Test..."
& fio --name=seq_read_q1 `
    --filename="$TEST_FILE" `
    --rw=read `
    --bs=1M `
    --size=1G `
    --numjobs=1 `
    --iodepth=1 `
    --runtime=10 `
    --time_based `
    --thread `
    --ioengine=mmap `
    --group_reporting

# Random 4K Q1T1
Write-Host "`nRunning Random 4K Q1T1 Test..."
& fio --name=rand_read_4k_q1 `
    --filename="$TEST_FILE" `
    --rw=randread `
    --bs=4K `
    --size=1G `
    --numjobs=1 `
    --iodepth=1 `
    --runtime=10 `
    --time_based `
    --thread `
    --ioengine=mmap `
    --group_reporting

Write-Host "`nAll tests completed!"

# Cleanup
# Remove-Item -Path $TEST_FILE -Force