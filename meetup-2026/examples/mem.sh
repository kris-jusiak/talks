rm -rf cache

perf bench asm 'add r11, [rax]' \
    --mode latency \
    --event cycles \
    --config.cache.L1d=hit_rate:100 \
    --name mov-hot \
    --output cache

perf bench asm 'add r11, [rax]' \
    --mode latency \
    --event cycles \
    --config.cache=cold \
    --name mov-cold \
    --output cache

perf plot -t ecdf -e cycles -- cache
