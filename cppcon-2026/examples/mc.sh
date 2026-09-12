#!/usr/bin/env bash
# Machine-code microbenchmarks for basic integer instructions.
# Measures each snippet on real hardware with `perf bench asm` (default
# prints a result table; --json pipes into `perf view`), then prints the
# llvm-mca prediction for the same snippet via `perf bench asm ... -D`.
set -euo pipefail

EVENTS="cycles,instructions"

have_mca=0
if command -v llvm-mca >/dev/null 2>&1; then
  have_mca=1
fi

bench_one() {
  local snippet="$1"
  shift
  echo "### perf: ${snippet} $*"
  # Human-readable result table (use --json | perf view for JSON).
  perf bench asm "${snippet}" -m latency -e "${EVENTS}" "$@"
  if [ "${have_mca}" -eq 1 ]; then
    echo "### llvm-mca: ${snippet}"
    perf bench asm "${snippet}" -m latency "$@" -D | llvm-mca -mcpu=alderlake 2>&1 | sed -n '1,40p' || true
  fi
  echo
}

# Scalar ALU (1 uop, 1c latency except where noted).
bench_one 'nop'
bench_one 'add eax, 42'
bench_one 'sub eax, 42'
bench_one 'xor eax, eax'
bench_one 'and eax, 42'
bench_one 'or eax, 42'
bench_one 'shl eax, 1'
bench_one 'shr eax, 1'
# 3-cycle latency.
bench_one 'imul eax, eax, 42'
# Stateful divider: single r/m operand, needs explicit state + repeat backend.
bench_one 'idiv ecx' --backend repeat --data.eax=100 --data.edx=0 --data.ecx=42
bench_one 'div ecx' --backend repeat --data.eax=100 --data.edx=0 --data.ecx=42
# Load-op (needs a backing address; explore solves [rax] when omitted).
bench_one 'add r11, [rax]'

if [ "${have_mca}" -eq 0 ]; then
  echo "(llvm-mca not found; skipped MCA comparison)" >&2
fi
