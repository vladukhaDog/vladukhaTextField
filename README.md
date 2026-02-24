# vladukhaTextField

A SwiftUI text field with a floating placeholder label, optional secure entry, custom validation, focus binding, and an optional toolbar Done button. Internally, it’s backed by a UIKit `UITextField` for fine‑grained control and reliable first‑responder behavior.

- Platform: iOS 15
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

## License

This project is source-available but not open source.
Use is permitted only via Swift Package Manager.
Modification, copying, or redistribution is prohibited.

## Example

```swift
            Section("doneButton(_:) Example") {
                VTextField("Donable", text: $text)
                    .doneButton(true)
                VTextField("No Donable", text: $text)
                    .doneButton(false)
            }
            Section("tfFocus(_:) Example") {
                VTextField("Tap to Focus", text: $text)
                    .tfFocus($isFocused)
                Toggle("Is Focused", isOn: $isFocused)
            }
            Section("textContentType(_:) Example") {
                VTextField("Email", text: $text)
                    .textFieldContentType(.emailAddress)
                VTextField("Password", text: $text)
                    .textFieldContentType(.password)
                VTextField("OTP", text: $text)
                    .textFieldContentType(.oneTimeCode)
            }
            Section("autocapitalizationMode(_:) Example") {
                VTextField("AllCharacters", text: $text)
                    .autocapitalizationMode(.allCharacters)
                VTextField("words", text: $text)
                    .autocapitalizationMode(.words)
            }
            Section("contentValidation(_:) Example") {
                VTextField("AllCharacters", text: $textNumbers)
                    .contentValidation { $0.allSatisfy(\ .isNumber) }
            }
            
            Section("secure(_:) Example") {
                VTextField("Secure", text: $text)
                    .secure(true)
            }
```

## Installation

Add the package to your project using Swift Package Manager:

1. In Xcode, choose File > Add Package Dependencies…
2. Enter the repository URL for this package.
3. Select the “vladukhaTextField” library product.

Or add it directly in your Package.swift:

```swift
.package(url: "https://github.com/your/repo/url.git", branch: "main"),
