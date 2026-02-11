// CustomModifiersExamples.swift
// Demonstrates all available custom modifiers with @State text
import SwiftUI

struct CustomModifiersExamples: View {
    @State private var text = ""
    @State private var textNumbers = ""
    @State private var isFocused = false
    @State private var contentType: UITextContentType? = .emailAddress
    
    var body: some View {
        Form {
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
        }
    }
}

#Preview {
    CustomModifiersExamples()
}
