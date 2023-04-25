task = {name: "downsampling_eum_sum_rp1h", every: 1h}

fromBucket = "eum"

toBucket = "eum/rp" + string(v: task.every)

data =
    from(bucket: fromBucket)
        |> range(start: -2h)

meanData =
    data
        |> filter(
            fn: (r) => r._field == "count" or r._field == "errorcount" or r._field == "counter" or r._field == "sum",
        )

meanData
    |> aggregateWindow(every: 1h, fn: sum)
    |> set(key: "aggregate", value: "sum")
    |> set(key: "rollup_interval", value: "1h")
    |> to(bucket: toBucket)
    |> yield(name: "sum")