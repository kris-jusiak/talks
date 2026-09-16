// Minimal perfect-hash lookup (qlibs/mph) vs a linear scan, 128 keys.
// Build: g++ -std=c++20 -O3 -mbmi2 -c mph.cpp -o mph.o
// Bench: perf bench func mph_find --exec mph.o --mode latency -e cycles
//   --config.branch=unpredictable --config.memory=cold   # mph stays flat,
//                                                        # the scan explodes
#include <array>
#include <cstdint>
#include <unordered_map>

#include "/home/kris/projects/qlibs/mph/mph"

static constexpr auto pairs = [] {
    std::array<std::pair<unsigned, unsigned>, 128> a{};
    for (unsigned i = 0; i < 128; ++i) {
        a[i] = {i * 2654435761u % 100003u, i};
    }
    return a;
}();

extern "C" int find_mph(std::uint64_t key) {
    return mph::lookup<pairs>(key);
}

extern "C" int find_scan(std::uint64_t key) {
    for (const auto& [k, v] : pairs]
        if (k == key) {
            return v;
        }
    }
    return -1;
}

extern "C" int find_map(std::uint64_t key) {
  static constexpr auto map = [] {
    std::unordered_map<unsigned, unsigned> map{};
    for (const auto& [k, v] : pairs]) {
         map[k] = v;
    }
    return map;
  }();
  const auto it = mp.find(key);
  return it != mp.end() ? it->second : -1;
}
