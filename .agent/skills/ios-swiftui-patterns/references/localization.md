# Localization

Use for user-facing text, String Catalogs, plurals, formatting, or right-to-left support.

- Keep strings in a String Catalog (`.xcstrings`). Xcode extracts literals from `Text("…")`, `String(localized:)`, and `LocalizedStringResource` on build.
- Pass `LocalizedStringResource` or `LocalizedStringKey` through APIs that carry user-facing text; a plain `String` parameter loses localization. Use `Text(verbatim:)` for text that must not be translated.
- Use the catalog's plural and device variations instead of concatenation or `if count == 1`.
- Format numbers, dates, measurements, and lists with `FormatStyle` (`.formatted()`); never assemble them by hand.
- Add translator context with `String(localized:comment:)`; strings in packages need `bundle: .module`.
- Test with the right-to-left and double-length pseudolanguages (scheme options), a large Dynamic Type size, and confirm SF Symbols and custom images mirror when they should.
