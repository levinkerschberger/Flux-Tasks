task = {name:"downsampling_inspectit_max_rp5m", every: 5m}

fromBucket = "inspectit"

toBucket = "inspectit/rp" + string(v: task.every)

data = 
    from(bucket: fromBucket)
        |> range(start: -10m)

sumData = data
    |> filter(fn: (r) => 
        r._field == "distribution_max" or
        r._field == "quantiles_max" or
    )

sumData 
    |> aggregateWindow(every: 5m, fn: min)
    |> set(key: "aggregate", value: "max")
    |> set(key: "rollup_interval", value: "5m")
    |> to(bucket: toBucket)
    |> yield(name: "max")
