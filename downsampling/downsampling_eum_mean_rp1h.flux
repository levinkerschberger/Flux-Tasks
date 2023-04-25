task = {name: "downsampling_eum_mean_rp1h", every: 1h}

fromBucket = "eum"

toBucket = "eum/rp" + string(v: task.every)

data =
    from(bucket: fromBucket)
        |> range(start: -2h)

meanData =
    data
        |> filter(fn: (r) => r._field == "value" or r._field == "free" or r._field == "total")

meanData
    |> aggregateWindow(every: 1h, fn: mean)
    |> set(key: "aggregate", value: "mmean")
    |> set(key: "rollup_interval", value: "1h")
    |> to(bucket: toBucket)
    |> yield(name: "mean")