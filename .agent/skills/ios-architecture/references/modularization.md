# Modularization with local packages

Use when splitting code into Swift packages or targets, fixing dependency cycles, or improving build times. Skip for small single-target apps unless requested.

## Decide

- Split for a concrete reason: build time, reuse across targets (app, extensions, widgets), enforced boundaries, or team ownership.
- Start with a few coarse modules, such as models, networking, design system, and one package per large feature. Split further only on evidence.

## Dependency rules

- The app target is the composition root: it builds concrete dependencies and wires features together.
- Features depend on shared modules, never on each other. Cross-feature navigation goes through routes or closures the app supplies.
- Shared modules never import feature or app code; keep UI out of model and networking modules.
- Add an interface-only module only to break a cycle or reduce rebuild fan-out.

## Mechanics

- Declare `platforms: [.iOS(…)]` to match the app, and add package products to the targets that use them.
- Use `public` for a module's API and `package` for internals shared between modules of one package.
- Package resources load from `Bundle.module`; pass `bundle: .module` for images, colors, and localized strings.
- Move files with `git mv` and keep behavior identical in the move commit.

## Verify

- Build the app and each package scheme. Run iOS-only package tests with `xcodebuild -scheme <Package> test`; use `swift test` only if the package also builds for macOS.
- Check for dependency cycles and for production code that relies on `@testable` imports.
