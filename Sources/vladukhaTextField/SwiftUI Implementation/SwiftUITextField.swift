
import SwiftUI
import Combine

/// A SwiftUI text field with a floating placeholder label, optional secure entry,
/// custom validation, focus binding, and an optional toolbar Done button.
/// Internally backed by a UIKit UITextField for fine-grained control.
public struct VTextField: View {
    /// Two-way binding to the text value.
    @Binding var text: String
    /// Content type hint (auto-fill and semantic meaning).
    @Environment(\.tfContentType) var textContentType: UITextContentType?
    /// Autocapitalization behavior.
    @Environment(\.tfAutocapitalization) var textInputAutocapitalization: UITextAutocapitalizationType
    /// Keyboard type to present.
    @Environment(\.tfKeyboardType) var keyboardType: UIKeyboardType
    /// Placeholder shown as a floating label.
    private let placeholder: String
    /// Whether the field uses secure text entry (password).
    @Environment(\.tfSecure) var secure: Bool
    /// Predicate used to validate or restrict text as it changes. Return false to block the edit.
    @Environment(\.tfContentValidation) var checkText: (String) -> Bool
    /// Whether to add a toolbar Done button above the keyboard.
    @Environment(\.tfDoneButton) var doneButton: Bool
    /// Called when the Return key is pressed.
    @Environment(\.tfOnCommit) var onCommit: () -> Void
    /// Two-way binding to focus (first responder) state. If not supplied, focus is unmanaged.
    @Environment(\.tfFocus) var focused: Binding<Bool>?
    
    /// Accessibility identifier assigned to the underlying UITextField.
    private let accessibilityIdentifier: String
    
    

    /// Creates a VTextField.
    /// - Parameters:
    ///   - text: Binding to the text value.
    ///   - checkText: Validation predicate for the next text value; return false to reject the change.
    ///   - accessibilityIdentifier: Accessibility identifier for the text field.
    ///   - focused: Optional binding to focus state; if omitted, focus is not controlled by SwiftUI.
    ///   - placeholder: Placeholder text shown as a floating label.
    ///   - textContentType: System content type hint for auto-fill and semantics.
    ///   - textInputAutocapitalization: Autocapitalization behavior (default: .sentences).
    ///   - keyboardType: Keyboard type (default: .default).
    ///   - secure: Whether to enable secure text entry (default: false).
    ///   - doneButton: Whether to show a toolbar Done button above the keyboard (default: false).
    ///   - onCommit: Called when the Return key is pressed (default: no-op).
    public init(_ title: String,
                text: Binding<String>,
                accessibilityIdentifier: String = ""
    ) {
        self._text = text
        self.placeholder = title
        self.accessibilityIdentifier = accessibilityIdentifier
    }
    
    public var body: some View {
        Group {
            UITextFieldRepresentable(text: $text,
                                     focused: .init(get: {
                return focused?.wrappedValue
            }, set: { newValue in
                if let newValue {
                    self.focused?.wrappedValue = newValue
                }
            }),
                                     accessibilityIdentifier: accessibilityIdentifier,
                                     checkText: checkText,
                                     placeholder: placeholder,
                                     textContentType: textContentType,
                                     textInputAutocapitalization: textInputAutocapitalization,
                                     keyboardType: keyboardType,
                                     secure: secure,
                                     doneButton: doneButton,
                                     onCommit: onCommit)
            .frame(height: 45)
        }
        
        .background(
            Material.thin
        )
        .clipShape(RoundedRectangle(cornerRadius: 10))
        
    }
}

#Preview {
    VStack {
        VTextField("Title", text: .constant("Text text text"))

    }
    .padding()
}

