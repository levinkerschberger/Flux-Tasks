task = {name: "downsampling_eum_min_rp1h", every: 1h}

fromBucket = "eum"

toBucket = "eum/rp" + string(v: task.every)

data =
    from(bucket: fromBucket)
        |> range(start: -2h)

meanData =
    data
        |> filter(fn: (r) => r._field == "distribution_min" or r._field == "quantiles_min")

meanData
    |> aggregateWindow(every: 1h, fn: min)
    |> set(key: "aggregate", value: "min")
    |> set(key: "rollup_interval", value: "1h")
    |> to(bucket: toBucket)
    |> yield(name: "min")