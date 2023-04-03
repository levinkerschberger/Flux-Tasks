option task = { name: "raw_instrumentation_state_queue_size", every: 5s }

from(bucket: "inspectit")
    |> range(start: -task.every)
    |> filter(fn: (r) => r._measurement == "jvm_classes_loaded" and r._field == "value")
    |> aggregateWindow(every: task.every, fn: last)
    |> set(key: "_measurement", value: "instrumentation_state")
    |> set(key: "_field", value: "loaded")
    |> to(bucket: "inspectit")