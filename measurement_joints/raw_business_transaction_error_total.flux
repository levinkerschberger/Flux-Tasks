option task = { name: "raw_business_transaction_error_total", every: 5s }

from(bucket: "inspectit")
    |> range(start: -task.every)
    |> filter(fn: (r) => r._measurement == "business_transaction_responsetime" and r._field == "count")
    |> aggregateWindow(every: task.every, fn: sum)
    |> set(key: "_measurement", value: "business_transaction_error")
    |> set(key: "_field", value: "count")
    |> to(bucket: "inspectit")