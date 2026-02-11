//
//  UITextFieldRepresentable.swift
//  vladukhaTextField
//
//  Created by Владислав Пермяков on 18.01.2026.
//
import UIKit
import SwiftUI

/// A SwiftUI wrapper around UITextField that provides a floating placeholder label,
/// validation via a custom predicate, focus control, and an optional toolbar Done button.
/// Use this indirectly via VTextField unless you need lower-level UIKit control.
internal struct UITextFieldRepresentable: UIViewRepresentable {
    /// Two-way binding to the text content of the field.
    @Binding var text: String
    /// Two-way binding that reflects and controls focus (first responder) state.
    @Binding var focused: Bool?
    /// An accessibility identifier applied to the underlying UITextField.
    let accessibilityIdentifier: String
    
    /// Predicate to validate or restrict text changes. Returning false prevents the change.
    let checkText: (String) -> Bool
    /// Placeholder text shown as a floating label.
    let placeholder: String
    /// Content type hint for the system (auto-fill, etc.).
    let textContentType: UITextContentType?
    /// Autocapitalization behavior.
    let textInputAutocapitalization: UITextAutocapitalizationType
    /// Keyboard type to display.
    let keyboardType: UIKeyboardType
    /// Whether the text entry is secure (password-style).
    let secure: Bool
    /// Whether to add a toolbar Done button above the keyboard.
    let doneButton: Bool
    /// Called when the return key is pressed.
    let onCommit: (() -> Void)
    
    /// Creates the root UIView container that hosts the UITextField and floating label.
    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        context.coordinator.storeView(view)
        return view
    }

    /// Keeps the UIKit view in sync with SwiftUI state (text and focus).
    func updateUIView(_ uiView: UIView, context: Context) {
        
        DispatchQueue.main.async {
            if focused == true, !context.coordinator.textField.isFocused {
                context.coordinator.textField.becomeFirstResponder()
            } else if focused == false {
                context.coordinator.textField.resignFirstResponder()
            }
        }
        if text != context.coordinator.textField.text {
            context.coordinator.textField.text = text
            context.coordinator.animateLabel()
        }
    }

    /// Creates the coordinator that acts as UITextField delegate and manages layout/animation.
    func makeCoordinator() -> UITextFieldCoordinator {
        UITextFieldCoordinator(text: $text,
                    checkText: checkText,
                    accessibilityIdentifier: accessibilityIdentifier,
                    focused: $focused,
                    placeholder: placeholder,
                    textContentType: textContentType,
                    textInputAutocapitalization: textInputAutocapitalization,
                    keyboardType: keyboardType,
                    secure: secure,
                    doneButton: doneButton,
                    onCommit: onCommit)
    }
    
    
    
}

