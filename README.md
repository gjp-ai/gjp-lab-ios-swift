# GJPLab iOS Feature Lab

GJPLab is a small SwiftUI app for learning current iOS fundamentals by reading, running, and extending self-contained working features. Each feature is a short, readable slice of real code with a matching requirement and design document.

## Features

A sidebar lists the categories; each category's catalogue marks topics as available (chevron) or planned (clock). On iPad the sidebar, catalogue, and feature sit side by side; on iPhone they collapse into one navigation stack.

| Category | Available | Planned |
| --- | --- | --- |
| SwiftUI | — | Views, layouts, text and input, buttons, selection, lists, navigation, animation, drawing, accessibility |
| HTTP Client | **URLSession**: build and send a request, inspect status, JSON body, and headers | Alamofire |
| Security | **Block App During Calls**: block the app while iOS reports an active call (disabled for the China App Store) | Screenshot detection, screen capture detection, sensitive content |
| Integration | **Firebase**: Analytics, Crashlytics, Remote Config, Performance Monitoring, and Cloud Messaging demos | — |
| Others | **OS & hardware**: iOS version, screen, model, CPU, and memory | — |

App-wide behavior: a branded splash screen, a Remote Config maintenance mode, and a Slate light/dark design system.

## Requirements

- Xcode 27.0 or later (iOS 27 SDK)
- iOS 26.6 or later (simulator or device)
- Swift 5 language mode, with default `MainActor` isolation
- Swift packages resolve automatically on first build (Firebase Apple SDK)

## Getting started

1. Open `GJPLab.xcodeproj` in Xcode and run the **GJPLab** scheme on an iPhone simulator.
2. Or build and test from the command line:

   ```bash
   xcodebuild -project GJPLab.xcodeproj -scheme GJPLab -configuration Debug \
     -destination 'generic/platform=iOS Simulator' -derivedDataPath build/DerivedData \
     CODE_SIGNING_ALLOWED=NO build

   DEVICE=$(.agent/skills/ios-build-release/scripts/pick-simulator.sh)
   xcodebuild -project GJPLab.xcodeproj -scheme GJPLab \
     -destination "platform=iOS Simulator,name=$DEVICE" -derivedDataPath build/DerivedData \
     CODE_SIGNING_ALLOWED=NO \
     -only-testing:GJPLabTests test
   ```

   `pick-simulator.sh` prints an available iPhone simulator, or exits with a recovery hint if the simulator service is stuck.

`GJPLab/GoogleService-Info.plist` is Firebase client configuration for the author's project. To send data to your own Firebase project, replace it with your own file. Push delivery, CallKit, and permission prompts need a physical device.

## Project structure

```
GJPLab/
├── app/          entry point, app delegate, SDK bootstrapper, root view;
│                 startup/ (splash, maintenance), navigation/ (navigation.json, sidebar, catalogue)
├── features/     <category>/<feature>/, one flat folder per feature (Firebase in integration/firebase/)
└── common/       config/ and theme/ (LabTheme, LabMark)
GJPLabTests/      Swift Testing unit tests
GJPLabUITests/    XCUITest UI tests
doc/              architecture/ and specs/ (mirrors GJPLab/)
resources/        editable app-icon SVGs
scripts/          render_app_icons.swift renders the app-icon PNG variants
```

## Documentation

Start with the [documentation index](doc/README.md). Project-wide docs live in `doc/architecture/`; each screen's requirement and detailed design live in `doc/specs/` at the same path as its code, for example [`doc/specs/features/httpclient/urlsession/`](doc/specs/features/httpclient/urlsession/).

## Working with coding agents

[`AGENTS.md`](AGENTS.md) holds the project rules, commands, and skill routing. Claude Code, Codex, and other agents read it directly. Reusable skills live in [`.agent/skills/`](.agent/skills/); `.claude/skills` is a symlink to the same folder so Claude Code discovers them too.
