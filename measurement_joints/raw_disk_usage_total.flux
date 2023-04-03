option task = { name: "raw_disk_usage_total", every: 5s }

from(bucket: "inspectit")
    |> range(start: -task.every)
    |> filter(fn: (r) => r._measurement == "disk_total" and r._field == "value")
    |> aggregateWindow(every: task.every, fn: last)
    |> set(key: "_measurement", value: "disk_usage")
    |> set(key: "_field", value: "total")
    |> to(bucket: "inspectit")