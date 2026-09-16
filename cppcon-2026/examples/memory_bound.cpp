// Backend bound [Memory Bound]: stream `n` bytes and commodity branch on
// each value. The benchmark controls how hot the buffer is (L1d hit rate),
// so the memory-bound vs branch split is visible in `cycles`.
//
// Build: g++ -std=c++23 -O3    memory_bound.cpp -o memory_bound.out
//        clang++ -std=c++23 -O3 memory_bound.cpp -o memory_bound.out
extern "C" long process(const unsigned char* arr, unsigned long n) {
    long total = 0;
    for (unsigned long i = 0; i < n; ++i) {
        const unsigned char v = arr[i]; // memory bound (L1d -> DRAM)
        if (v & 1) {                    // branch (predictable)
            total += v;
        } else {
            total -= v;
        }
    }
    return total;
}