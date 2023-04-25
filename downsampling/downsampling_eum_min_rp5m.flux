task = {name: "downsampling_eum_min_rp5m", every: 5m}

fromBucket = "eum"

toBucket = "eum/rp" + string(v: task.every)

data =
    from(bucket: fromBucket)
        |> range(start: -10m)

meanData =
    data
        |> filter(fn: (r) => r._field == "distribution_min" or r._field == "quantiles_min")

meanData
    |> aggregateWindow(every: 5m, fn: min)
    |> set(key: "aggregate", value: "min")
    |> set(key: "rollup_interval", value: "5m")
    |> to(bucket: toBucket)
    |> yield(name: "min")