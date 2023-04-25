task = {name: "downsampling_eum_sum_rp5m", every: 5m}

fromBucket = "eum"

toBucket = "eum/rp" + string(v: task.every)

data =
    from(bucket: fromBucket)
        |> range(start: -10m)

meanData =
    data
        |> filter(
            fn: (r) => r._field == "count" or r._field == "errorcount" or r._field == "counter" or r._field == "sum",
        )

meanData
    |> aggregateWindow(every: 5m, fn: sum)
    |> set(key: "aggregate", value: "sum")
    |> set(key: "rollup_interval", value: "5m")
    |> to(bucket: toBucket)
    |> yield(name: "sum")