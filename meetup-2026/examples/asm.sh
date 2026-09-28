perf bench asm 'imul eax, 0' --mode latency -e cycles -o insn
perf bench asm 'add  eax, 0' --mode latency -e cycles -o insn
perf bench asm 'sub  eax, 0' --mode latency -e cycles -o insn
perf bench asm 'cdq; idiv ecx;' --mode latency -e cycles -o insn
perf plot -t bar -- insn
