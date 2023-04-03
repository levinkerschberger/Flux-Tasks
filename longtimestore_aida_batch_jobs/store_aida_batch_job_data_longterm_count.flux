task = {name:"store_aida_batch_job_data_longterm_count", every: 1m}

fromBucket = "inspectit"

toBucket = "inspectit/batch_job_raw"

data = 
    from(bucket: fromBucket)
        |> range(start: -15m)

lastData = data
    |> filter(fn: (r) => 
        r._measurement =~ /aida_batch.*/ or
        r._field == "count"
        )

lastData 
    |> aggregateWindow(every: 1ns, fn: last)
    |> set(key: "_field", value: "count")
    |> set(key: "aggregate", value: "last")
    |> set(key: "rollup_interval", value: "1m")
    |> to(bucket: toBucket)
    |> yield(name: "last_aida")
