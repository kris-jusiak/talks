extern "C" int sum(const char* data, int n) {
    auto sum = 0;
    for (auto i = 0; i < n; ++i) {
        sum += data[i];
    }
    return sum;
}
