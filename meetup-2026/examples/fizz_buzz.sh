#!/usr/bin/env bash
# Bad Speculation [Branch Mispredicts]: fizz_buzz crossed with
# branch predictability and input distribution. Predictable inputs pin
# one path (~0 misses/op); shuffled inputs sample all four paths
# (~1 miss/op). Same battery as the `bench` alias in the deck.
# Numbers below are Alder Lake i7-12650H medians; yours will differ.
set -euo pipefail
cd "$(dirname "$0")"

g++ -O2 -o fizz fizz.c
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
rm -rf "${ROOT}/data/branch"

bench() { # name [args...]
  local name="$1"
  shift
  perf bench func fizz_buzz --exec fizz --name "${name}" \
    --mode latency --event branch-misses,cycles,instructions \
    -o "${ROOT}/data/branch" "$@"
}

bench predictable        --config.branch=predictable
bench unpredictable      --config.branch=unpredictable
bench arg0-0             --data.arg0=0   --config.branch=predictable
bench arg0-1             --data.arg0=1   --config.branch=predictable
bench arg0-3             --data.arg0=3   --config.branch=predictable
bench arg0-5             --data.arg0=5   --config.branch=predictable
bench arg0-15            --data.arg0=15  --config.branch=predictable
bench seq-15-predictable --data.arg0="[$(seq 1 15)]"   --config.branch=predictable
bench seq-15-unpredict   --data.arg0="[$(seq 1 15)]"   --config.branch=unpredictable
bench seq-1024-predictable --data.arg0="[$(seq 1 1024)]" --config.branch=predictable
bench seq-1024-unpredict --data.arg0="[$(seq 1 1024)]" --config.branch=unpredictable
bench shuf-15-predictable  --data.arg0="[$(shuf -i 1-15)]"   --config.branch=predictable
bench shuf-15-unpredict  --data.arg0="[$(shuf -i 1-15)]"   --config.branch=unpredictable
bench shuf-1024-predictable --data.arg0="[$(shuf -i 1-1024)]" --config.branch=predictable
bench shuf-1024-unpredict --data.arg0="[$(shuf -i 1-1024)]" --config.branch=unpredictable

perf plot -t ecdf -e branch-misses -- "${ROOT}/data/branch"