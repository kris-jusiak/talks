#!/usr/bin/env bash
set -euo pipefail

rm -rf sort.so
g++ -O3 -shared -fPIC -o sort.so sort.cpp

rm -rf sort
perf bench func sort --name sort-1 -m latency -x sort.so --data.arg0=0x10000000 --data.arg1=1 "--data[0x10000000:]=[$(seq 1 1)]" -o sort
perf bench func sort --name sort-4 -m latency -x sort.so --data.arg0=0x10000000 --data.arg1=4 "--data[0x10000000:]=[$(seq 1 4)]" -o sort
perf bench func sort --name sort-8 -m latency -x sort.so --data.arg0=0x10000000 --data.arg1=8 "--data[0x10000000:]=[$(seq 1 8)]" -o sort
perf bench func sort --name sort-16 -m latency -x sort.so --data.arg0=0x10000000 --data.arg1=16 "--data[0x10000000:]=[$(seq 1 16)]" -o sort
perf bench func sort --name sort-32 -m latency -x sort.so --data.arg0=0x10000000 --data.arg1=32 "--data[0x10000000:]=[$(seq 1 32)]" -o sort
perf bench func sort --name sort-64 -m latency -x sort.so --data.arg0=0x10000000 --data.arg1=64 "--data[0x10000000:]=[$(seq 1 64)]" -o sort
perf bench func sort --name sort-128 -m latency -x sort.so --data.arg0=0x10000000 --data.arg1=128 "--data[0x10000000:]=[$(seq 1 128)]" -o sort
perf plot -g '' -t line -x data.arg1 -- sort

rm -rf sort2
perf bench func sort --name sort-64-seq -m latency -x sort.so --data.arg0=0x10000000 --data.arg1=64 "--data[0x10000000:]=[$(seq 64 -1 1)]" -o sort2
perf bench func sort --name sort-64-shuf -m latency -x sort.so --data.arg0=0x10000000 --data.arg1=64 "--data[0x10000000:]=[$(shuf -i 1-64)]" -o sort2
perf plot -- sort2
