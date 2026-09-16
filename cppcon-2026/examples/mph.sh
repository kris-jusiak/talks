#!/usr/bin/env bash
# Minimal perfect-hash lookup (qlibs/mph, 128 keys): a branchless
# pext + LUT load (find_mph) vs a linear scan (find_scan) vs an
# std::unordered_map lookup (find_map) across branch predictability.
# find_mph stays flat (~1-3 cycles); the scan/map pay heavily for
# unpredictable input.
#
# Notes:
#   - Built as a shared object: find_map pulls in libstdc++ (guard/new/
#     unordered_map) which the plain-`gcc` linker driver of `perf bench`
#     cannot resolve; a .so is used in place.
#   - `-fno-exceptions` keeps the object linkable by `perf bench` (its
#     linker driver is plain `gcc`, no libstdc++); `--config.memory` was
#     renamed to `--config.cache` in perf-labs.
#   - Events are cycles,instructions (one `-e`, comma form shares a single
#     measurement row). A lone `-e cycles` currently reads a constant ~1
#     cycle for such tiny functions; the second event forces a correctly
#     scheduled counter.
#   - `--config.cache=hot|cold` sets the data-cache levels, steering the
#     per-lookup table (rodata) in memory; hot (~1-5cy) vs cold (~44cy)
#     brackets the data-cache effect, and branch contrast is the other axis.
set -euo pipefail
cd "$(dirname "$0")"

g++ -std=c++20 -O3 -mbmi2 -fno-exceptions -fno-rtti -fno-unwind-tables \
  -fPIC -shared -I "${HOME}/projects/qlibs/mph" \
  mph.cpp -o mph.so

PLOT_CONFIG="$(mktemp)"
trap 'rm -f "${PLOT_CONFIG}"' EXIT
cat > "${PLOT_CONFIG}" <<'JSON'
{ "figure.figsize": [11, 5], "figure.dpi": 100 }
JSON

# Inspect the emitted asm interactively with: perf bench func find_mph --exec mph.so -S

rm -rf ../data/mph
for func in find_scan find_map find_mph; do
  for branch in predictable unpredictable; do
    for memory in hot cold; do
      echo "### ${func} branch=${branch} memory=${memory}"
      perf bench func "${func}" --name "${func}-${branch}-${memory}" \
        --exec mph.so --mode latency \
        -e cycles,instructions \
        --config.branch="${branch}" --config.cache="${memory}" \
        -o ../data/mph
    done
  done
done
perf view -e cycles,instructions/cycles -s p99 -- ../data/mph
perf plot --config "${PLOT_CONFIG}" -t ecdf -e cycles -e instructions/cycles \
  -o ../images/mph_ecdf.png -- ../data/mph