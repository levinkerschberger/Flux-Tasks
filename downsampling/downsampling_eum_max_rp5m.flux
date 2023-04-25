task = {name: "downsampling_eum_max_rp5m", every: 5m}

fromBucket = "eum"

toBucket = "eum/rp" + string(v: task.every)

data =
    from(bucket: fromBucket)
        |> range(start: -10m)

meanData =
    data
        |> filter(fn: (r) => r._field == "distribution_max" or r._field == "quantiles_max")

meanData
    |> aggregateWindow(every: 5m, fn: max)
    |> set(key: "aggregate", value: "max")
    |> set(key: "rollup_interval", value: "5m")
    |> to(bucket: toBucket)
    |> yield(name: "max")