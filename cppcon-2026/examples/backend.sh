#!/usr/bin/env bash
# Backend bound: compiler axis (gcc vs clang) crossed with how hot the
# input buffer is (L1d hit rate 100/50/0). The hotter the buffer, the
# more the function is branch-bound; the colder, the more memory-bound.
# Numbers below are Alder Lake i7-12650H medians; yours will differ.
set -euo pipefail
cd "$(dirname "$0")"

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
mkdir -p "${ROOT}/data/backend"
g++     -std=c++23 -O3 -c memory_bound.cpp -o "${ROOT}/data/backend/memory_gcc.o"
clang++ -std=c++23 -O3 -c memory_bound.cpp -o "${ROOT}/data/backend/memory_clang.o"

PAYLOAD="$(python3 -c 'print(",".join(str((i*37)%256) for i in range(256)))')"
for obj in memory_gcc.o memory_clang.o; do
  for hit_rate in 100 50 0; do
    echo "### ${obj} L1d hit_rate=${hit_rate}"
    perf bench func process --exec "${ROOT}/data/backend/${obj}" --mode latency -e cycles \
      --data.arg0=0x10000000 --data.arg1=256 \
      "--data[0x10000000:]=[${PAYLOAD}]" \
      --config.cache.L1d="hit_rate:${hit_rate}" \
      --config.branch=predictable \
      -o "${ROOT}/data/backend"
  done
done
perf plot -t ecdf -e cycles -- "${ROOT}/data/backend"