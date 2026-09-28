#!/usr/bin/env bash

rm -rf branch

bench() {
    perf bench func fizz_buzz \
        --exec /tmp/branch \
        --mode latency \
        --event cycles \
        --output branch \
        $@
}

bench --name "predictable.arg0=[0]" --data.arg0=0 --config.branch=predictable
bench --name "predictable.arg0=[3]" --data.arg0=3 --config.branch=predictable
bench --name "predictable.arg0=[1,2,3,...]" --data.arg0="[$(seq -s, 1 10000)]" --config.branch=predictable
bench --name "predictable" --config.branch=predictable

bench --name "unpredictable.arg0=[0]" --data.arg0=0 --config.branch=unpredictable
bench --name "unpredictable.arg0=[3]" --data.arg0=3 --config.branch=unpredictable
bench --name "unpredictable.arg0=[1,2,3,...]" --data.arg0="[$(seq -s, 1 10000)]" --config.branch=unpredictable
bench --name "unpredictable" --config.branch=unpredictable
