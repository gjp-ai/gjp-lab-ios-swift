# Test selection

Choose the cheapest test that exercises the behavior and fails for the intended regression.

| Behavior | Prefer |
| --- | --- |
| Pure mapping, policy, state transition, repository with fakes | Swift Testing or XCTest unit test |
| Async API contract, cancellation, actor behavior | Unit test with controllable fakes/clock/URL protocol |
| SwiftUI semantics, interaction, focus, navigation | XCUITest or focused view-level testing available in the host |
| Permission, entitlement, APNs, asset, lifecycle, system UI behavior | Simulator or physical-device test |
| Cross-boundary critical contract | Small end-to-end path only when lower tests cannot prove it |

- Assert observable behavior, not incidental hierarchy or pixel coordinates unless visual fidelity is the contract.
- Control time, randomness, storage, network, and remote configuration. Avoid fixed delays; wait on observable state with a bound.
- Cover relevant failure, empty, cancellation, scene/lifecycle, and accessibility paths without duplicating equivalent assertions.
- State simulator/device, locale, Dynamic Type, appearance, network, signing, or Firebase prerequisites that affect results.
