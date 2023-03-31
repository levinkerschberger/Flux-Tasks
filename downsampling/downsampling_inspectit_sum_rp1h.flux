task = {name:"downsampling_inspectit_sum_rp1h", every: 1h}

fromBucket = "inspectit"

toBucket = "inspectit/rp" + string(v: task.every)

data = 
    from(bucket: fromBucket)
        |> range(start: -2h)

sumData = data
    |> filter(fn: (r) => 
        r._field == "count" or
        r._field == "errorcount" or
        r._field == "counter" or
        r._field == "sum" or 
        r._field == "histogram_bucket"
    )

sumData 
    |> aggregateWindow(every: 1h, fn: sum)
    |> set(key: "aggregate", value: "sum")
    |> set(key: "rollup_interval", value: "1h")
    |> to(bucket: toBucket)
    |> yield(name: "sum")
