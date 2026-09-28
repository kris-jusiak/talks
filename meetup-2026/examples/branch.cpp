#include <perf/perf.hpp>
#include <cstdio>
#include <iostream>
#include <cstdlib>

[[gnu::noinline]] const char* fizz_buzz(int n) {
  if (n % 15 == 0) {
    return "FizzBuzz";
  } else if (n % 3 == 0) {
    return "Fizz";
  } else if (n % 5 == 0) {
    return "Buzz";
  } else {
    //std::puts("unknown");
    return "Unknown";
  }
}

int main(int argc, char**) {
  while (true) {
    auto x = std::rand();
    PERF_LABEL(foo_begin);
    std::cout << fizz_buzz(x);
    PERF_LABEL(foo_end);
  }
}
