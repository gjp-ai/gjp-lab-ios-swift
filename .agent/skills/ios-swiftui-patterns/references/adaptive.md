# Adaptive layout guide

Use this reference only when the product scope includes iPad, split view, Stage Manager, rotation, external display, resizing, or multiple display widths.

- Adapt to the proposed container size and content relationship, not a device-name or orientation check.
- Preserve navigation context, text input, selection, and scroll position while the window changes size.
- Choose a single pane, responsive grid, or `NavigationSplitView` because it improves the task—not merely because a width threshold changed.
- Keep compact layouts complete. Expanded layouts should reveal useful simultaneous context instead of stretching controls across empty space.
- Test compact and expanded widths, Dynamic Type, rotation/resizing, and split-view behavior relevant to the feature.
