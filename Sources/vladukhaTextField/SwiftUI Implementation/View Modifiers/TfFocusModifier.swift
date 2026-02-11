//
//  TfFocusModifier.swift
//  vladukhaTextField
//
//  Created by vladukha on 11.02.2026.
//

import SwiftUI

extension View {
    /// Binds the focus (first responder) state of a VTextField to a binding.
    ///
    /// Use this to programmatically control or observe whether the field is currently focused (showing the keyboard).
    ///
    /// - Parameter focus: An optional `Binding<Bool>` controlling and reflecting focus state. Pass `nil` for default unmanaged focus.
    /// - Returns: A modified view with the environment value set.
    ///
    /// Example:
    /// ```swift
    /// @FocusState var isFocused: Bool
    /// VTextField(text: $text, placeholder: "Field")
    ///     .tfFocus($isFocused)
    /// ```
    ///
    /// __Platform:__ iOS, iPadOS
    public func tfFocus(_ focus: Binding<Bool>?) -> some View {
        self.environment(\.tfFocus, focus)
    }
}
