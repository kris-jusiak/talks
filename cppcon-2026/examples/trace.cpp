// Minimal trace example: two functions sharing the same scalar
// signature `(seed, n) -> int64_t` (rdi = seed, rsi = length).
//
//   - steady  : predictable stride-1 accumulation (retiring)
//   - branchy : data-dependent ~50/50 branches (bad speculation)
//
// Concrete inputs are required (symbolic `n` can solve to astronomic trip
// counts), so every bench passes `--data` (or a collected `--trace`):
//
//   perf bench func "steady|branchy" --mode latency --exec trace.out \
//     --data.rdi=42 --data.rsi=256
//
// Build:
//   g++ -O2 -g -fno-omit-frame-pointer -o trace.out trace.cpp
//
// The `extern "C"` + `noinline` attributes keep stable symbol names for
// wildcard matching (`perf bench func --list`, bpftrace uprobes).

#include <cstdint>
#include <cstdio>
#include <cstdlib>

extern "C" __attribute__((noinline)) int64_t steady(int64_t seed, int64_t n) {
    int64_t acc = seed;
    for (int64_t i = 0; i < n; ++i) {
        acc += (seed + i) * 3 + i;
    }
    return acc;
}

extern "C" __attribute__((noinline)) int64_t branchy(int64_t seed, int64_t n) {
    int64_t a = seed, b = 0;
    for (int64_t i = 0; i < n; ++i) {
        uint64_t x = (uint64_t)seed * 0x9e3779b1u + (uint64_t)i * 0x85ebca6bu;
        x ^= x >> 17;
        if (x & 1) {
            a += (int64_t)x;
        } else {
            a -= (int64_t)x;
        }
        if (x & 0x100) {
            b += a;
        } else {
            b -= a;
        }
    }
    return a + b;
}

int main(int argc, char** argv) {
    int64_t n = argc > 1 ? atoll(argv[1]) : 1024;
    int64_t seed = argc > 2 ? atoll(argv[2]) : 42;
    if (n < 1) {
        n = 1;
    }

    volatile int64_t sink = 0;
    sink += steady(seed, n);
    sink += branchy(seed, n);
    printf("steady=%lld branchy=%lld total=%lld\n", (long long)steady(seed, n),
           (long long)branchy(seed, n), (long long)sink);
    return (int)(sink == 0x12345678);
}
