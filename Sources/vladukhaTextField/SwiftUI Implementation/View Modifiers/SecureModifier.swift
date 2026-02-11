//
//  SecureModifier.swift
//  vladukhaTextField
//
//  Created by vladukha on 11.02.2026.
//

import SwiftUI

extension View {
    /// Sets whether a VTextField or compatible field should use secure (password-style) text entry.
    ///
    /// When enabled, the input obscures characters for privacy, for use with passwords or sensitive information.
    ///
    /// - Parameter secure: Pass `true` to enable secure entry (characters hidden), or `false` for normal text.
    /// - Returns: A modified view with the environment value set.
    ///
    /// Example:
    /// ```swift
    /// VTextField(text: $password, placeholder: "Password")
    ///     .secure(true)
    /// ```
    ///
    /// __Platform:__ iOS, iPadOS
    public func secure(_ secure: Bool) -> some View {
        self.environment(\.tfSecure, secure)
    }
}
