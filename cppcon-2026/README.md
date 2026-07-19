### https://kris-jusiak.github.io/talks/cppcon-2026

https://github.com/perf-labs/perf

Motivation
- transistions (moore law)
- goals: how fast, what if, why so
- tools: profiling,benchmarking,analyzing,testing <- no bias (noise from cpu/os)
- bias (hw/os effects)
  - perf info cpu (lstopo)
  - cache effects
     - L1-RAM - picture
  - branches
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

Analyzing:
  - angr/mca/uica
  - ecdf (doesn't lose value)

Testing:
  - need reproducable results (angr/angr)
    perf.bench(asm).instrucitons < 10

Summary:
  correlation
