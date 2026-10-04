# Feature: Error handling

Status: Implemented

## Goal

Show how Swift functions report failure and how callers handle, convert, or pass on errors.

## Scope

### In scope

- Defining errors as an enum that conforms to `Error`.
- `throws`, `try`, and `do`/`catch` with pattern-matched catch clauses.
- Typed throws (`throws(ValidationError)`).
- `try?` turning an error into `nil`, and why `try!` is avoided.
- `Result` and `get()`.
- `defer` running cleanup on both success and failure.

### Out of scope

- `async` throwing functions (see Concurrency).
- `NSError` bridging.

## Behavior

- The topic is a page of runnable samples: opening, running, and leaving it behave as the [runnable code sample requirement](../../../common/codesample/codesample_requirement.md) describes.
- Each throwing sample runs with an input that succeeds and one that fails, so both paths appear in the output.
- The *try? and try!* sample never runs `try!` on a failing call; it explains the crash and runs the `try?` version.

## UI & Navigation

- Entry point: **Swift** category → **Error handling** catalogue item (route `errorHandling`).
- Samples, in order: **throws, do, and catch**, **Typed throws**, **try? and try!**, **Result**, **defer**.

## Rules & Constraints

- The shared rules in the [runnable code sample requirement](../../../common/codesample/codesample_requirement.md#rules--constraints) apply: the code shown is the code that runs, no sample crashes or touches the network, and output is the same on every run.
- No sample uses `try!` on a call that can throw at run time.

## Platform limitations

- None.

## Acceptance criteria

The shared criteria [CS-AC-01 to CS-AC-07](../../../common/codesample/codesample_requirement.md#acceptance-criteria) also apply.

| ID | Scenario | Expected result |
| --- | --- | --- |
| ERR-AC-01 | Run the *defer* sample | The cleanup line is printed for both the success and the failure run. |
| ERR-AC-02 | Run the *Typed throws* sample | The catch clause receives the concrete error type and prints its case. |

## Technical implementation constraints

- Source lives in `GJPLab/features/swift/errors/`: `ErrorHandlingScreen.swift` and `ErrorHandlingSamples.swift`.
- `FeatureRoute.errorHandling` maps to `ErrorHandlingScreen` in `ContentView.feature(for:)`; the topic in `app/navigation/navigation.json` (Swift category, id `swift`) carries `"route": "errorHandling"`.
- The topic supplies only its `CodeSample` list; the page and cards are shared from `GJPLab/common/codesample/`.
- No new dependencies and no view models.

## Related documents

- [Detailed design](errors_detail_design.md)
- [Runnable code sample requirement](../../../common/codesample/codesample_requirement.md)
- Swift tutorial: [Error handling](../../../../guides/swift_tutorial.md#11-error-handling)
