task = {name: "downsampling_eum_mean_rp5m", every: 5m}

fromBucket = "eum"

toBucket = "eum/rp" + string(v: task.every)

data =
    from(bucket: fromBucket)
        |> range(start: -10m)

meanData =
    data
        |> filter(fn: (r) => r._field == "value" or r._field == "free" or r._field == "total")

meanData
    |> aggregateWindow(every: 5m, fn: mean)
    |> set(key: "aggregate", value: "mean")
    |> set(key: "rollup_interval", value: "5m")
    |> to(bucket: toBucket)
    |> yield(name: "mean")