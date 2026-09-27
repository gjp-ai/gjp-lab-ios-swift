# Availability patterns

## Checking availability

```swift
if #available(iOS 27, *) {
    useNewAPI()
} else {
    useFallback()
}

guard #available(iOS 27, *) else { return fallbackResult }

@available(iOS 27, *)
func featureThatNeedsNewAPI() { … }
```

- Prefer `#available` at the narrowest point that needs it; mark whole types `@available` only when all of their API is new.
- Use `if #unavailable(iOS N)` when only the old path needs special handling.

## SwiftUI modifiers

Wrap version-specific modifiers in one helper so view structure stays the same on every OS:

```swift
extension View {
    @ViewBuilder
    func newStyleIfAvailable() -> some View {
        if #available(iOS 27, *) {
            self.newModifier()
        } else {
            self
        }
    }
}
```

## Deprecating your own API

Mark internal APIs you are replacing with `@available(*, deprecated, renamed: "newName")` so the compiler lists every caller, then remove the old API once callers have moved.

## Do not

- Silence deprecation warnings with compiler flags or wrapper indirection.
- Check `UIDevice.current.systemVersion` strings instead of using `#available`.
- Leave a fallback branch that is never tested; if it cannot be tested, report it.
