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
    @Binding var focused: Bool
    /// An accessibility identifier applied to the underlying UITextField.
    let accessibilityIdentifier: String
    /// If true, focus changes are not driven by the `focused` binding.
    let noFocus: Bool
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
        if !noFocus {
            DispatchQueue.main.async {
                if focused, !context.coordinator.textField.isFocused {
                    context.coordinator.textField.becomeFirstResponder()
                } else if !focused {
                    context.coordinator.textField.resignFirstResponder()
                }
            }
        }
        if text != context.coordinator.textField.text {
            context.coordinator.textField.text = text
            context.coordinator.animateLabel()
        }
    }

    /// Creates the coordinator that acts as UITextField delegate and manages layout/animation.
    func makeCoordinator() -> Coordinator {
        Coordinator(text: $text,
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
    
    private enum LabelState {
        case active
        case inactive
    }

    /// Coordinator that manages UITextField delegate callbacks, layout, validation, and the floating label animation.
    class Coordinator: NSObject, UITextFieldDelegate {
        
        /// Designated initializer for the coordinator.
        /// - Parameters:
        ///   - text: Binding to the text content.
        ///   - checkText: Predicate to validate the next text value (return false to block).
        ///   - accessibilityIdentifier: Accessibility identifier for the text field.
        ///   - focused: Binding to focus state.
        ///   - placeholder: Placeholder string for the floating label.
        ///   - textContentType: System content type hint.
        ///   - textInputAutocapitalization: Autocapitalization behavior.
        ///   - keyboardType: Keyboard type.
        ///   - secure: Whether the field is secure text entry.
        ///   - doneButton: Whether to add a toolbar Done button.
        ///   - onCommit: Callback when return is pressed.
        init(text: Binding<String>,
             checkText: @escaping (String) -> Bool,
             accessibilityIdentifier: String,
             focused: Binding<Bool>,
             placeholder: String,
             textContentType: UITextContentType?,
             textInputAutocapitalization: UITextAutocapitalizationType,
             keyboardType: UIKeyboardType,
             secure: Bool,
             doneButton: Bool,
             onCommit: @escaping () -> Void) {
            self.text = text
            self.focused = focused
            self.placeholder = placeholder
            self.textContentType = textContentType
            self.textInputAutocapitalization = textInputAutocapitalization
            self.keyboardType = keyboardType
            self.secure = secure
            self.onCommit = onCommit
            self.accessibilityIdentifier = accessibilityIdentifier
            self.checkText = checkText
            self.doneButton = doneButton
        }

        /// The root container view that hosts the text field and label.
        private var view: UIView?
        /// The underlying UITextField.
        let textField: UITextField = .init()
        /// The floating placeholder label.
        private let label = UILabel()
        
        // Constraints that will be animated
        private var labelTopConstraint: NSLayoutConstraint!
        private var labelCenterYConstraint: NSLayoutConstraint!
        
        /// Binding to text.
        var text: Binding<String>
        /// Binding to focus state.
        var focused: Binding<Bool>
        /// Text validation predicate; returning false blocks the edit.
        var checkText: (String) -> Bool
        /// Placeholder text for the floating label.
        var placeholder: String!
        /// System content type hint.
        var textContentType: UITextContentType?
        /// Autocapitalization behavior.
        var textInputAutocapitalization: UITextAutocapitalizationType!
        /// Keyboard type.
        var keyboardType: UIKeyboardType!
        /// Secure text entry flag.
        var secure: Bool!
        /// Commit callback on return key.
        var onCommit: (() -> Void)!
        /// Whether to add a toolbar Done button above the keyboard.
        var doneButton: Bool
        /// Accessibility identifier for the text field.
        var accessibilityIdentifier: String!
        
        /// Configures the UIKit view hierarchy and prepares constraints and behaviors.
        /// - Parameter view: The container view provided by SwiftUI.
        func storeView(_ view: UIView) {
            self.view = view
            textField.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
            textField.delegate = self
            textField.translatesAutoresizingMaskIntoConstraints = false
            if textField.text != text.wrappedValue {
                textField.text = text.wrappedValue
            }
            textField.textContentType = textContentType
            textField.autocapitalizationType = textInputAutocapitalization
            textField.keyboardType = keyboardType
            textField.isSecureTextEntry = secure
            textField.accessibilityIdentifier = accessibilityIdentifier
            textField.autocorrectionType = .no
            
            textField.backgroundColor = .clear
            textField.tintColor = .init(Color.accentColor)
            
            // padding of a text
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 40))
                
            textField.leftView = paddingView
            textField.leftViewMode = .always
            
            view.backgroundColor = .init(Color.clear)
            view.addSubview(textField)
            
            label.text = placeholder
            label.alpha = 0.4
            
            label.translatesAutoresizingMaskIntoConstraints = false
            view.addSubview(label)
            
            view.layer.cornerRadius = 10
            view.clipsToBounds = true
            
            // Label Constraints
            labelTopConstraint = label.topAnchor.constraint(equalTo: view.topAnchor, constant: 2)
            labelCenterYConstraint = label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
            
            NSLayoutConstraint.activate([
                textField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
                textField.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                textField.topAnchor.constraint(equalTo: view.topAnchor, constant: 0),
                textField.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
                label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10),
                labelCenterYConstraint
                
            ])
            if doneButton {
                addDoneButtonOnKeyboard()
            }
            self.animateLabel()
        }
        
        /// UITextFieldDelegate: Validates proposed text changes using `checkText`.
        func textField(_ textField: UITextField,
                       shouldChangeCharactersIn range: NSRange,
                       replacementString string: String) -> Bool {
            // get the current text, or use an empty string if that failed
            let currentText = textField.text ?? ""

            // attempt to read the range they are trying to change, or exit if we can't
            guard let stringRange = Range(range, in: currentText) else { return false }

            // add their new text to the existing text
            let updatedText = currentText.replacingCharacters(in: stringRange, with: string)

            return checkText(updatedText)
        }
        
        /// Propagates text changes from UITextField to the SwiftUI binding.
        @objc private func textFieldChanged(_ sender: UITextField) {
            text.wrappedValue = sender.text ?? ""
        }
        
        /// Handles the Return key: resigns first responder and calls `onCommit`.
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.textField.resignFirstResponder()
            self.onCommit()
            return true
        }
        
        /// Updates focus binding and animates label on begin editing.
        func textFieldDidBeginEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                if !self.focused.wrappedValue {
                    self.focused.wrappedValue = true
                }
            }
            animateLabel()
        }
        
        /// Updates focus binding and animates label on end editing.
        func textFieldDidEndEditing(_ textField: UITextField) {
            DispatchQueue.main.async {
                if self.focused.wrappedValue {
                    self.focused.wrappedValue = false
                }
            }
            animateLabel()
        }
        
        /// Adds a toolbar with a Done button above the keyboard.
        func addDoneButtonOnKeyboard() {
            let doneToolbar: UIToolbar = UIToolbar(frame: CGRect.init(x: 0, y: 0,
                                                                      width: UIScreen.main.bounds.width,
                                                                      height: 50))
            doneToolbar.barStyle = .default
            
            let flexSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace,
                                            target: nil,
                                            action: nil)
            let done: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.done,
                                                        target: self,
                                                        action: #selector(self.doneButtonAction))
            
            let items = [flexSpace, done]
            doneToolbar.items = items
            doneToolbar.sizeToFit()
            
            textField.inputAccessoryView = doneToolbar
        }
        
        /// Resigns first responder in response to the toolbar Done button.
        @objc func doneButtonAction() {
            textField.resignFirstResponder()
        }

        /// Changes the layer anchor point of a view without visual jump by adjusting its position.
        private func setAnchorPoint(_ anchorPoint: CGPoint, forView view: UIView) {
            var newPoint = CGPoint(x: view.bounds.size.width * anchorPoint.x,
                                   y: view.bounds.size.height * anchorPoint.y)
            
            var oldPoint = CGPoint(x: view.bounds.size.width * view.layer.anchorPoint.x,
                                   y: view.bounds.size.height * view.layer.anchorPoint.y)

            newPoint = newPoint.applying(view.transform)
            oldPoint = oldPoint.applying(view.transform)

            var position = view.layer.position
            position.x -= oldPoint.x
            position.x += newPoint.x

            position.y -= oldPoint.y
            position.y += newPoint.y

            view.layer.position = position
            view.layer.anchorPoint = anchorPoint
        }
        
        /// Animates the floating label between centered and compact top-aligned states
        /// depending on focus and whether the text is empty.
        func animateLabel() {
            UIView.animate(withDuration: 0.1, animations: {
                if self.textField.isFirstResponder || self.textField.text?.isEmpty == false {
                    self.setAnchorPoint(CGPoint(x: 1, y: 1), forView: self.label)
                    self.label.transform = CGAffineTransform(scaleX: 0.5, y: 0.5)
                    self.labelCenterYConstraint.isActive = false
                    self.labelTopConstraint.isActive = true
                } else {
                    self.setAnchorPoint(CGPoint(x: 0.5, y: 0.5), forView: self.label)
                    self.label.transform = .identity
                    self.labelTopConstraint.isActive = false
                    self.labelCenterYConstraint.isActive = true
                }
                self.view?.layoutIfNeeded()
                
            })
        }
    }
}

