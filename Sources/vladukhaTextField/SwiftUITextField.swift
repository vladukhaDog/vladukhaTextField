
import SwiftUI
import Combine

/// A SwiftUI text field with a floating placeholder label, optional secure entry,
/// custom validation, focus binding, and an optional toolbar Done button.
/// Internally backed by a UIKit UITextField for fine-grained control.
public struct VTextField: View {
    /// Two-way binding to the text value.
    @Binding var text: String
    /// Content type hint (auto-fill and semantic meaning).
    private let textContentType: UITextContentType?
    /// Autocapitalization behavior.
    private let textInputAutocapitalization: UITextAutocapitalizationType
    /// Keyboard type to present.
    private let keyboardType: UIKeyboardType
    /// Placeholder shown as a floating label.
    private let placeholder: String
    /// Whether the field uses secure text entry (password).
    private let secure: Bool
    /// Predicate used to validate or restrict text as it changes. Return false to block the edit.
    private let checkText: (String) -> Bool
    /// Whether to add a toolbar Done button above the keyboard.
    private let doneButton: Bool
    /// Called when the Return key is pressed.
    private let onCommit: () -> Void
    /// Two-way binding to focus (first responder) state. If not supplied, focus is unmanaged.
    @Binding private var focused: Bool
    /// Indicates that focus management is disabled because no binding was provided.
    private let noFocus: Bool
    /// Internal cancellable storage (unused currently).
    private var cancellable = Set<AnyCancellable>()
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
    public init(text: Binding<String>,
         checkText: @escaping (String) -> Bool = {_ in return true},
         accessibilityIdentifier: String,
         focused: Binding<Bool>? = nil,
         placeholder: String,
         textContentType: UITextContentType? = nil,
         textInputAutocapitalization: UITextAutocapitalizationType = .sentences,
         keyboardType: UIKeyboardType = .default,
         secure: Bool = false,
         doneButton: Bool = false,
         onCommit: @escaping () -> Void = {}
    ) {
        self._text = text
        self.placeholder = placeholder
        self.textContentType = textContentType
        self.textInputAutocapitalization = textInputAutocapitalization
        self.checkText = checkText
        self.keyboardType = keyboardType
        self.secure = secure
        self.onCommit = onCommit
        self._focused = focused ?? .constant(false)
        self.noFocus = focused == nil
        self.accessibilityIdentifier = accessibilityIdentifier
        self.doneButton = doneButton
    }
    
    public var body: some View {
        Group {
            UITextFieldRepresentable(text: $text,
                                     focused: $focused,
                                     accessibilityIdentifier: accessibilityIdentifier,
                                     noFocus: noFocus,
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
        
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke(Material.regular, lineWidth: 1)
        )

    }
}

#Preview {
    VStack {
        VTextField(text: .constant("Text text text"), accessibilityIdentifier: "", placeholder: "Text Placeholdder")
        VTextField(text: .constant(""), accessibilityIdentifier: "", placeholder: "placeholder")
        VTextField(text: .constant("Text text text"), accessibilityIdentifier: "", placeholder: "Text Placeholdder")
        VTextField(text: .constant(""), accessibilityIdentifier: "", focused:.constant(true), placeholder: "placeholder")
    }
    .padding()
}

