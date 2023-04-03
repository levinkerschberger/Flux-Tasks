task = {name:"store_aida_batch_job_data_longterm_sum", every: 1m}

fromBucket = "inspectit"

toBucket = "inspectit/batch_job_raw"

data = 
    from(bucket: fromBucket)
        |> range(start: -15m)

lastData = data
    |> filter(fn: (r) => 
        r._measurement =~ /aida_batch.*/ or
        r._field == "sum"
        )

lastData 
    |> aggregateWindow(every: 1ns, fn: sum)
    |> set(key: "_field", value: "sum")
    |> set(key: "aggregate", value: "last")
    |> set(key: "rollup_interval", value: "1m")
    |> to(bucket: toBucket)
    |> yield(name: "last_aida")
