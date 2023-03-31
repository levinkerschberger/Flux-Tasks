task = {name:"downsampling_inspectit_min_rp5m", every: 5m}

fromBucket = "inspectit"

toBucket = "inspectit/rp" + string(v: task.every)

data = 
    from(bucket: fromBucket)
        |> range(start: -10m)

sumData = data
    |> filter(fn: (r) => 
        r._field == "distribution_min" or
        r._field == "quantiles_min" or
    )

sumData 
    |> aggregateWindow(every: 5m, fn: min)
    |> set(key: "aggregate", value: "min")
    |> set(key: "rollup_interval", value: "5m")
    |> to(bucket: toBucket)
    |> yield(name: "min")
