### https://kris-jusiak.github.io/talks/cppcon-2026

https://github.com/perf-labs/perf

Disclaimer
- read intel manual
- then read angr
- then experiment

Motivation
- transistions (moore law)
- goals: how fast, what if, why so
- tools: profiling,benchmarking,analyzing,testing <- no bias (noise from cpu/os)
- bias (hw/os effects)
  - perf info cpu (lstopo)
  - cache effects
     - L1-RAM - picture
     - nonstream temporary access [TIP]
  - branches [TIP]
     - fwd no-taken
     - bkw taken
     - never-taken (no entry in BTB)
  - layout
    - reshuffle, stack, heap, ...

Benchmarking:
  - studying/undersatnding
  - answer what if (not as if)
    - the volume will spike tomorrow - show some VIX charts
    - use the same binary (don't fight compiler)

  - idea symbolic execution
    - load elf
    - relocate
    - analyze (angr) / may require help with a perf run
    - bench -> distrubtuion best->worst 

  - examples
      - smallest hash table vs lookup table (mph) - cache (fpga)
      - simd - throughput (gpu, tpu)
      - fizz_buzz for branching

Profiling:
    - help to fix it (affects execution - see bias)
    - sampling/tracing(intel_pt) - effects on results
        - use the same binary 
    - top-down
    - profile regions not functions (inlining, setup)
    - inline function (different version each time)
    - latency vs throughput
    - you wanna be fast you wanna be in the future speculative [TIP]

Analyzing:
  - angr/mca/uica
  - ecdf (doesn't lose value)

Testing:
  - need reproducable results (angr/angr)
    perf.bench(asm).instrucitons < 10

Summary:
  correlation

Code:
"loop.begin"_label;
"loop.end"_label;

Intel Xeon
    L1 - 4ns
        keep()
        fence()
    L2 - 13ns
        flush()
        fence()
        settle()
        prefetch()
    L3 - 75ns
        keep()
        demote()
        settle()
    RAM - 294ns
        flush()
        fence()

Chart
    images/vix.png

Usage:
    --topdown use perf info labels siimlar to probs
    perf record -e cycles:ppp -- ./your_app
    perf report --start-address=0x7f1234000000 --stop-address=0x7f1234002000


No code changes


INTEL(R) XEON(R)
AMD EPYC

prefetch/demote
dL1: 4ns
dL2: 13ns
dL3: 77ns
RAM: 294ns

prefetch
dL1: 4ns
dL2: 13ns
dL3: 13ns
RAM: 294ns

demote
dL1: 4ns
dL2: 77ns
dL3: 77ns
RAM: 294ns

rust,zig
