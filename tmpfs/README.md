# Docker에서 tmpfs를 사용해 FIO 벤치마크를 실행하기

1. 이미지 빌드:

```bash
docker build -t fio-tmpfs-test .
```

2. tmpfs를 마운트하여 컨테이너 실행:

```bash
docker run --rm \
  --mount type=tmpfs,destination=/mnt/tmpfs \
  fio-tmpfs-test
```

## Description

1. Ubuntu 22.04 기반으로 최신 안정 버전의 FIO를 사용
2. tmpfs를 /mnt/tmpfs에 마운트
3. 세 가지 주요 테스트 실행:
   - 순차 읽기 (Q8T1)
   - 순차 읽기 (Q1T1)
   - 랜덤 4K 읽기 (Q1T1)
4. libaio 엔진 사용으로 Linux 네이티브 성능 측정
5. direct=1 설정으로 OS 캐시 우회

## Options

- 파일 크기 (--size)
- 실행 시간 (--runtime)
- 블록 크기 (--bs)
- Queue depth (--iodepth)
