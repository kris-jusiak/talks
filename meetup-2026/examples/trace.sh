#!/usr/bin/env bash
#
set -euo pipefail

[ "${1:-}" = "--" ] && shift

#perf record -e branches:u -e cache-misses:u -j any -o perf.data -- \
#
sudo bpftrace \
    -e "uprobe:$1:steady { printf(\"%s\\n\", func); printf(args); }" \
    -c "$*"
