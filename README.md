# vladukhaTextField

A SwiftUI text field with a floating placeholder label, optional secure entry, custom validation, focus binding, and an optional toolbar Done button. Internally, it’s backed by a UIKit `UITextField` for fine‑grained control and reliable first‑responder behavior.

- Platform: iOS 13+, extremely cool!
- Language: Swift
- Package Type: Swift Package

## Features

- Floating placeholder label that animates between centered and compact top‑aligned states
- Optional secure text entry (password fields)
- Custom validation via a predicate to accept/reject edits
- Two‑way focus binding to control and observe first responder
- Keyboard customization (type, autocapitalization, content type)
- Optional toolbar Done button above the keyboard
- Accessibility identifier passthrough to the underlying `UITextField`

## Example

```swift
VTextField(
    text: $text,
    checkText: { proposed in
        // Return true to accept the change, false to reject.
        // Example: allow only digits and max length 6
        let isDigits = proposed.allSatisfy(\.isNumber)
        return isDigits && proposed.count <= 6
    },
    accessibilityIdentifier: "pinField",
    focused: $isFocused, // Optional: bind focus
    placeholder: "Enter PIN",
    textContentType: .oneTimeCode, // System hint for auto-fill
    textInputAutocapitalization: .none,
    keyboardType: .numberPad,
    secure: true, // Secure entry
    doneButton: true, // Show toolbar Done button
    onCommit: {
        // Called when Return is pressed
        submit()
    }
)
```

## Installation

Add the package to your project using Swift Package Manager:

1. In Xcode, choose File > Add Package Dependencies…
2. Enter the repository URL for this package.
3. Select the “vladukhaTextField” library product.

Or add it directly in your Package.swift:

```swift
.package(url: "https://github.com/your/repo/url.git", branch: "main"),
