//
//  KeyboardTypeModifier.swift
//  vladukhaTextField
//
//  Created by vladukha on 11.02.2026.
//

import SwiftUI

extension View {
    /// Sets the keyboard type for a VTextField or compatible text input.
    ///
    /// This modifier controls the visual style of the keyboard presented to the user, such as number pad, email, or default.
    ///
    /// - Parameter keyboardType: The `UIKeyboardType` to use (e.g., `.default`, `.numberPad`, `.emailAddress`).
    /// - Returns: A modified view with the environment value set.
    ///
    /// Use this to optimize the keyboard for the expected input.
    ///
    /// Example:
    /// ```swift
    /// VTextField(text: $pin, placeholder: "PIN")
    ///     .keyboardType(.numberPad)
    /// ```
    ///
    /// __Platform:__ iOS, iPadOS
    public func keyboardType(_ keyboardType: UIKeyboardType) -> some View {
        self.environment(\.tfKeyboardType, keyboardType)
    }
}
