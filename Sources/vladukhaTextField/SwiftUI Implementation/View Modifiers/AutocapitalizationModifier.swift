//
//  File.swift
//  vladukhaTextField
//
//  Created by vladukha on 11.02.2026.
//

import SwiftUI

extension View {
    /// Sets whether a VTextField or compatible field should use specific autocapitalization policy
    ///
    ///
    /// - Parameter mode: Pass ``UITextAutocapitalizationType`` to specify autocapitalization policy
    /// - Returns: A modified view with the environment value set.
    ///
    /// Example:
    /// ```swift
    /// VTextField(text: $password, placeholder: "Password")
    ///     .autocapitalizationMode(.never)
    /// ```
    ///
    /// __Platform:__ iOS, iPadOS
    public func autocapitalizationMode(_ mode: UITextAutocapitalizationType) -> some View {
        self.environment(\.tfAutocapitalization, mode)
    }
}
