option task = { name: "raw_instrumentation_state_instrumented", every: 5s }

from(bucket: "inspectit")
    |> range(start: -task.every)
    |> filter(fn: (r) => r._measurement == "inspectit_self_instrumented_classes" and r._field == "value")
    |> aggregateWindow(every: task.every, fn: last)
    |> set(key: "_measurement", value: "instrumentation_state")
    |> set(key: "_field", value: "instrumented")
    |> to(bucket: "inspectit")