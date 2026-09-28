rm -rf data/
perf bench func fizz_buzz --exec /tmp/branch --mode latency -o data/
perf bench func fizz_buzz --exec /tmp/branch --mode throughput -o data/
perf plot -t ecdf -e duration_time/operations -- data/
