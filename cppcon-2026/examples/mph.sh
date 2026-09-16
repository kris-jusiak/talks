#!/usr/bin/env bash
# Minimal perfect-hash lookup (qlibs/mph, 128 keys): a branchless
# pext + LUT load (mph_find) vs a linear scan (scan_find) across branch
# predictability. mph_find stays flat (~3 cycles); the scan pays heavily for
# unpredictable input.
#
# Notes:
#   - `-fno-exceptions` keeps the object linkable by `perf bench` (its
#     linker driver is plain `gcc`, no libstdc++); `--config.memory` was
#     renamed to `--config.cache` in perf-labs.
#   - Events are cycles,instructions (one `-e`, comma form shares a single
#     measurement row). A lone `-e cycles` currently reads a constant ~1
#     cycle for such tiny functions; the second event forces a correctly
#     scheduled counter.
#   - `--config.cache=hot|cold` sets the data-cache levels, but the mph/scan
#     tables live in the object's rodata and are not address-steered yet, so
#     hot vs cold come out the same; the branch contrast is the measurement.
set -euo pipefail
cd "$(dirname "$0")"

g++ -std=c++20 -O3 -mbmi2 -fno-exceptions -fno-rtti -fno-unwind-tables \
  -c mph.cpp -o mph.o

# Inspect the emitted asm interactively with: perf bench func mph_find --exec mph.o -S

rm -rf ../data/mph
for func in mph_find scan_find; do
  for branch in predictable unpredictable; do
    for memory in hot cold; do
      echo "### ${func} branch=${branch} memory=${memory}"
      perf bench func "${func}" --name "${func}-${branch}-${memory}" \
        --exec mph.o --mode latency \
        -e cycles,instructions \
        --config.branch="${branch}" --config.cache="${memory}" \
        -o ../data/mph
    done
  done
done
perf view -e cycles,instructions/cycles -s p99 -- ../data/mph
perf plot -t ecdf -e cycles -- ../data/mph