task = {name:"downsampling_inspectit_min_rp1h", every: 1h}

fromBucket = "inspectit"

toBucket = "inspectit/rp" + string(v: task.every)

data = 
    from(bucket: fromBucket)
        |> range(start: -2h)

sumData = data
    |> filter(fn: (r) => 
        r._field == "distribution_min" or
        r._field == "quantiles_min" or
    )

sumData 
    |> aggregateWindow(every: 1h, fn: min)
    |> set(key: "aggregate", value: "min")
    |> set(key: "rollup_interval", value: "1h")
    |> to(bucket: toBucket)
    |> yield(name: "min")
