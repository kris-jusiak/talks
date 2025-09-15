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

Bonus

----

#### Always measure - https://valgrind.org/docs/manual/cl-manual.html
<!-- .element: style="text-align:left" -->

```cpp
 └─ System
    └── Application

          int main() {
            prof::callgrind profiler{"simulation"};

            while (true) {
              profiler.reset();
              profiler.start();

              if (trigger) { // fast-path
                // action

                profiler.stop();
                profiler.flush();
              }
            }
          }
```

```sh
        valgrind --tool=callgrind --instr-atstart=no \ # 5x-100x overhead
          --cache-sim=yes --branch-sim=yes --collect-jumps=yes --dump-instr=yes ...
```
<!-- .element: style="font-size:18px;" -->

----

```cpp
int main() {
  perf::runner bench{
    timeit{.iterations = 1u,     .samples = 1u},
    timeit{.iterations = 10'000, .samples = 1u},
    timeit{.iterations = 1,      .samples = 100},
    timeit{.iterations = 10'000, .samples = 100},
    timeit{}, // estimated
  };

  bench(fizz_buzz, {});

  perf::plot::bar(bench[
    perf::stat::tsc / perf::bench::operations,
    perf::stat::steady_time / perf::bench::operations
  ]);
}
```
<!-- .element: style="font-size:15px;" -->

<p align="left">
<img src="images/is.png" style="width: 90%; background:none; border:none; box-shadow:none;  margin: 0 0;" />
</p>

----

#### trace & record & mca
<!-- .element: style="text-align:left" -->

```cpp
perf::profiler profiler{
  perf::trace::instructions,
  perf::trace::cycles,        // cyc_thresh
  perf::record::mem_loads,    // PEBS
};

profiler.start();
// ...
profiler.stop();

perf::analyzer analyzer{perf::mca::assembly};
analyzer << profiler[perf::trace::instructions];

perf::annotate(tuple(analyzer[], profiler[])[
  perf::mca::assembly,
  perf::trace::instructions / perf::trace::cycles, // IPC per IP
  perf::record::mem_loads                          // L1d, L2d, L3d, TLBi hit/miss
]);
```
<!-- .element: style="font-size:17px" -->

----

#### Baseline
<!-- .element: style="text-align:left" -->

```cpp
int main() {
  perf::runner bench{perf::bench::latency{}};

  bench(baseline(fizz_buzz), unpredictable<int>);
  bench(fizz_buzz_fast_mod,  unpredictable<int>);
  bench(fizz_buzz_lut,       unpredictable<int>);

  auto ops = perf::bench::operations;

  perf::report(bench[perf::stat::tsc / ops], p50, p99);
  perf::plot::ecdf(bench[perf::stat::tsc / ops]);
}
```
<!-- .element: style="font-size:21px;" -->

----

```cpp
benchmark                                           [1]           [2]
-----------------------------------------  ------------  ------------
fiz_buzz(unpredictable)/latency[*]         (1.00x) 8.16  (1.00x) 9.19
fizz_buzz_fast_mod(unpredictable)/latency  (1.45x) 5.64  (1.50x) 6.13
fizz_buzz_lut(unpredictable)/latency       (0.89x) 9.15  (1.00x) 9.22

[*] baseline
(0) speedup(slowest:1.00x) // against the baseline
[1] p50((stat.tsc[ns]/bench.operations))
[2] p99((stat.tsc[ns]/bench.operations))

```
<!-- .element: style="font-size:20px;" -->

<p align="left">
<img src="images/baseline.png" style="width: 90%; background:none; border:none; box-shadow:none;" />
</p>

----

#### [https://github.com/qlibs/perf#studies](https://github.com/qlibs/perf/discussions/4)
<!-- .element: style="text-align:left" -->

```cpp
// "Code can tell you what works, not what doesn't"
```
<!-- .element: style="text-align:left" -->

```sh
 user@perf:~$ ./fizz_buzz | export.sh html | gh gist create --public # markdown, notebook
```
<!-- .element: style="text-align:left;font-size:13px;" -->

<p align="left">
&nbsp; <img src="images/gh_html.png" style="width: 75%; background:none; border:none; box-shadow:none;" />
</p>
<!-- .element: style="margin: -30px 0;" -->

----

