#include "../namedtuple.hpp"

struct x{};

int main() {
  auto t = namedtuple(
      "0"_t = 0,
      "1"_t = std::string_view{},
      "2"_t = true,
      "3"_t = 0u,
      "4"_t = .0,
      "5"_t = 'x',
      "6"_t = x{},
      "7"_t = 0ull,
      "8"_t = short{},
      "9"_t = 42.f,
      "10"_t = 0,
      "11"_t = std::string_view{},
      "12"_t = true,
      "13"_t = 0u,
      "14"_t = .0,
      "15"_t = 'x',
      "16"_t = x{},
      "17"_t = 0ull,
      "18"_t = short{},
      "19"_t = 42.f,
      "20"_t = 0,
      "21"_t = std::string_view{},
      "22"_t = true,
      "23"_t = 0u,
      "24"_t = .0,
      "25"_t = 'x',
      "26"_t = x{},
      "27"_t = 0ull,
      "28"_t = short{},
      "29"_t = 42.f,
      "30"_t = 0,
      "31"_t = std::string_view{},
      "32"_t = true,
      "33"_t = 0u,
      "34"_t = .0,
      "35"_t = 'x',
      "36"_t = x{},
      "37"_t = 0ull,
      "38"_t = short{},
      "39"_t = 42.f,
      "40"_t = 0,
      "41"_t = std::string_view{},
      "42"_t = true,
      "43"_t = 0u,
      "44"_t = .0,
      "45"_t = 'x',
      "46"_t = x{},
      "47"_t = 0ull,
      "48"_t = short{},
      "49"_t = 42.f,
      "50"_t = 0,
      "51"_t = std::string_view{},
      "52"_t = true,
      "53"_t = 0u,
      "54"_t = .0,
      "55"_t = 'x',
      "56"_t = x{},
      "57"_t = 0ull,
      "58"_t = short{},
      "59"_t = 42.f,
      "60"_t = 0,
      "61"_t = std::string_view{},
      "62"_t = true,
      "63"_t = 0u,
      "64"_t = .0,
      "65"_t = 'x',
      "66"_t = x{},
      "67"_t = 0ull,
      "68"_t = short{},
      "69"_t = 42.f,
      "70"_t = 0,
      "71"_t = std::string_view{},
      "72"_t = true,
      "73"_t = 0u,
      "74"_t = .0,
      "75"_t = 'x',
      "76"_t = x{},
      "77"_t = 0ull,
      "78"_t = short{},
      "79"_t = 42.f,
      "80"_t = 0,
      "81"_t = std::string_view{},
      "82"_t = true,
      "83"_t = 0u,
      "84"_t = .0,
      "85"_t = 'x',
      "86"_t = x{},
      "87"_t = 0ull,
      "88"_t = short{},
      "89"_t = 42.f,
      "90"_t = 0,
      "91"_t = std::string_view{},
      "92"_t = true,
      "93"_t = 0u,
      "94"_t = .0,
      "95"_t = 'x',
      "96"_t = x{},
      "97"_t = 0ull,
      "98"_t = short{},
      "99"_t = 42.f
  );

  t["0"_t];
  t["1"_t];
  t["2"_t];
  t["3"_t];
  t["4"_t];
  t["5"_t];
  t["6"_t];
  t["7"_t];
  t["8"_t];
  t["9"_t];
  t["10"_t];
  t["11"_t];
  t["12"_t];
  t["13"_t];
  t["14"_t];
  t["15"_t];
  t["16"_t];
  t["17"_t];
  t["18"_t];
  t["19"_t];
  t["20"_t];
  t["21"_t];
  t["22"_t];
  t["23"_t];
  t["24"_t];
  t["25"_t];
  t["26"_t];
  t["27"_t];
  t["28"_t];
  t["29"_t];
  t["30"_t];
  t["31"_t];
  t["32"_t];
  t["33"_t];
  t["34"_t];
  t["35"_t];
  t["36"_t];
  t["37"_t];
  t["38"_t];
  t["39"_t];
  t["40"_t];
  t["41"_t];
  t["42"_t];
  t["43"_t];
  t["44"_t];
  t["45"_t];
  t["46"_t];
  t["47"_t];
  t["48"_t];
  t["49"_t];
  t["50"_t];
  t["51"_t];
  t["52"_t];
  t["53"_t];
  t["54"_t];
  t["55"_t];
  t["56"_t];
  t["57"_t];
  t["58"_t];
  t["59"_t];
  t["60"_t];
  t["61"_t];
  t["62"_t];
  t["63"_t];
  t["64"_t];
  t["65"_t];
  t["66"_t];
  t["67"_t];
  t["68"_t];
  t["69"_t];
  t["70"_t];
  t["71"_t];
  t["72"_t];
  t["73"_t];
  t["74"_t];
  t["75"_t];
  t["76"_t];
  t["77"_t];
  t["78"_t];
  t["79"_t];
  t["80"_t];
  t["81"_t];
  t["82"_t];
  t["83"_t];
  t["84"_t];
  t["85"_t];
  t["86"_t];
  t["87"_t];
  t["88"_t];
  t["89"_t];
  t["90"_t];
  t["91"_t];
  t["92"_t];
  t["93"_t];
  t["94"_t];
  t["95"_t];
  t["96"_t];
  t["97"_t];
  t["98"_t];
  t["99"_t];
}
