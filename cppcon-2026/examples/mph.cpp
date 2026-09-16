// g++ -std=c++20 -O3 mph.cpp -I ~/projects/qlibs/mph/ -mbmi2 -c mph.o
#include <array>
#include <cstdint>
#include <unordered_map>
#include <mph>

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
    for (const auto& [k, v] : pairs) {
        if (k == key) {
            return v;
        }
    }
    return -1;
}

extern "C" int find_map(std::uint64_t key) {
  static const auto map = [] {
    std::unordered_map<unsigned, unsigned> map{};
    for (const auto& [k, v] : pairs) {
         map[k] = v;
    }
    return map;
  }();
  const auto it = map.find(key);
  return it != map.end() ? it->second : -1;
}

int main(){}
