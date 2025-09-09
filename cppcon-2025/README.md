### https://kris-jusiak.github.io/talks/cppcon-2025

Code
- https://godbolt.org/z/xrvrrPx4j

Vidoes
- https://www.youtube.com/watch?v=7YVMC5v4qCA
- https://www.youtube.com/watch?v=zWxSZcpeS8Q
- https://www.youtube.com/watch?v=Czr5dBfs72U
- https://www.youtube.com/watch?v=K62EMzueWwA

Resources
- https://github.com/qlibs/perf/discussions/3
- https://github.com/qlibs/perf/discussions/4
- https://lemire.github.io/talks/2025/sea/sea2025.html
- https://en.algorithmica.org/hpc
- https://lucisqr.substack.com/p/leveraging-llvm-mca?r=2laeyk
- https://probablydance.com/2025/05/31/im-open-sourcing-my-custom-benchmark-gui/
- https://emeryberger.com/research/stabilizer/ / https://github.com/ccurtsinger/stabilizer
- https://travisdowns.github.io/blog/2019/06/11/speed-limits.html

Notes:
  - nansosecond count more for some than others
  - wind-tunnel F1 corelaction - if' it's not correlated dont's ship it (if you expected slower but it got faster what you do? ship-it?)
  - iterate - that' show you get deep understanding
  - you have a sirvey of 1000 people and ask just one 1000 times
  - testing in production-like lab might be expensive (production)
  - cpu increateing throughput but not as much latency
  - no hypthosies - lets'try that and that -> profile
    ├─ Do you have code?      - code alignment, icache, ...
    ├─ Do you have functions? - stack frame size, ...
    ├─ Do you have branches?  - branch aliasing, ...
    ├─ Do you have loops?     - crossing boundary, ...
    ├─ Do you access memory?  - data alignment, cache, heap, ...
  - cause profile for multithreading
  - run in new process note

TODO
  - console picture for sixel
  - flowgraph picute
  - complexity graph (big0)
  - intel manual quotes
  - nops examples (alignment)
  - mph example (memory)
  - normal distribution?
  - Front-end Bound / Backend Bound (which counters)
  - max_ipc?
  - is_elided?
  - pack struct - dod
  - perf::thread::set_affinity(self, 2);
  - perf::thread::set_priority(self, max);

Slides
- normal distrubution picture
    - show that mean make no sense (sound statistics) / multiple runs

- SHOW graphs for all benchmark runs (together)

- Intel manual quotes
    - branching (form the llvm talk)
    - nops (from the tuturial)

Slides Fixups
- analyzer (just labels no invoke, invoke just in testing)
- jupyter notebook is out of place
- annotate with source (more often)
- fixup uops latency (unroll)
- memory (pollute_heap vs overload operator new)

- change fizz_buzz to no branching and branching -> but it's slower because of memory

TODO
- add mph (for memory caching lut) / lookup table in register vs lookup table in cache
- add nop (example with for-loop for alignment)
- add big0 complexity (example)
- ecdf (add vs fizz_buzz or fizz_buzz static vs unpredictable)
- annotate (opt.pass) // requires clang -frecord

Features
- disable perf (asm goto)
- opt.pass
- flowgraph
- flamegraph
    - fixup for rdpmc in spec
- fixup for godbolt cpuid name

  perf::verify(perf::info::cpu::features().contains("avx512"));
  perf::verify(perf::info::cpu::dispatch_width() >= 4u);
