task = {name: "downsampling_eum_max_rp1h", every: 1h}

fromBucket = "eum"

toBucket = "eum/rp" + string(v: task.every)

data =
    from(bucket: fromBucket)
        |> range(start: -2h)

meanData =
    data
        |> filter(fn: (r) => r._field == "distribution_max" or r._field == "quantiles_max")

meanData
    |> aggregateWindow(every: 1h, fn: max)
    |> set(key: "aggregate", value: "max")
    |> set(key: "rollup_interval", value: "1h")
    |> to(bucket: toBucket)
    |> yield(name: "max")