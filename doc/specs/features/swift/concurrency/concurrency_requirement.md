# Feature: Concurrency

Status: Implemented

## Goal

Show how Swift runs work concurrently and safely: async functions, parallel child tasks, cancellation, and actors.

## Scope

### In scope

- `async`/`await` calling a function that suspends.
- `async let` and `withTaskGroup` running work in parallel and collecting results.
- Cancellation: a long task that checks `Task.isCancelled` and stops early.
- An actor protecting a counter that many tasks update.
- `@MainActor` and `@concurrent`: which work runs on the main actor in this app and how to move work off it.

### Out of scope

- `AsyncSequence` and `AsyncStream`.
- Swift 6 language-mode migration (the app uses Swift 5 mode).

## Behavior

- The topic is a page of runnable samples: opening, running, and leaving it behave as the [runnable code sample requirement](../../../common/codesample/codesample_requirement.md) describes.
- Samples that wait (`async`/`await`, `async let`, cancellation) use short sleeps that stand in for network calls; each finishes in under a second.
- Leaving the topic cancels the sample's whole task tree, including child tasks in a task group, because the samples use structured concurrency.

## UI & Navigation

- Entry point: **Swift** category → **Concurrency** catalogue item (route `concurrency`).
- Samples, in order: **async and await**, **async let**, **Task groups**, **Cancellation**, **Actors**, **Main actor and @concurrent**.

## Rules & Constraints

- The shared rules in the [runnable code sample requirement](../../../common/codesample/codesample_requirement.md#rules--constraints) apply: the code shown is the code that runs, no sample crashes or touches the network, and output is the same on every run.
- Samples use structured concurrency (`async let`, task groups) rather than unstructured `Task {}`, so cancellation reaches every child task.
- Output never includes timings, thread names, or completion order that varies between runs; parallel results are sorted before printing.

## Platform limitations

- Scheduling differs between the simulator and a device, so samples must not rely on which task finishes first.

## Acceptance criteria

The shared criteria [CS-AC-01 to CS-AC-07](../../../common/codesample/codesample_requirement.md#acceptance-criteria) also apply.

| ID | Scenario | Expected result |
| --- | --- | --- |
| CON-AC-01 | Run the *Task groups* sample | Results from every child task are printed in sorted order, identical on every run. |
| CON-AC-02 | Run the *Cancellation* sample | The output reports that counting stopped early. |
| CON-AC-03 | Run the *Actors* sample | The final count equals the number of increments (1,000), every time. |
| CON-AC-04 | Run the *Main actor and @concurrent* sample | The output shows the sample starts on the main thread and the `@concurrent` work does not run on it. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swift/concurrency/`: `ConcurrencyScreen.swift` and `ConcurrencySamples.swift`.
- `FeatureRoute.concurrency` maps to `ConcurrencyScreen` in `ContentView.feature(for:)`; the topic in `app/navigation/navigation.json` (Swift category, id `swift`) carries `"route": "concurrency"`.
- The topic supplies only its `CodeSample` list; the page and cards are shared from `GJPLab/common/codesample/`.
- No new dependencies and no view models.

## Related documents

- [Detailed design](concurrency_detail_design.md)
- [Runnable code sample requirement](../../../common/codesample/codesample_requirement.md)
- Swift tutorial: [Concurrency: async, await, and tasks](../../../../guides/swift_tutorial.md#13-concurrency-async-await-and-tasks)
