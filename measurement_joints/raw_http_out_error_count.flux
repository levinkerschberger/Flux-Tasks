option task = { name: "raw_http_out_error_count", every: 5s }

from(bucket: "inspectit")
    |> range(start: -task.every)
    |> filter(fn: (r) => r._measurement == "http_out_responsetime" and r._field == "count" and r.error == "true")
    |> aggregateWindow(every: task.every, fn: sum)
    |> set(key: "_measurement", value: "http_out_error")
    |> set(key: "_field", value: "errorcount")
    |> to(bucket: "inspectit")