//
//  ContentValidationModifier.swift
//  vladukhaTextField
//
//  Created by vladukha on 11.02.2026.
//

import SwiftUI

extension View {
    /// Sets a validation predicate for a VTextField or compatible field.
    ///
    /// Use this modifier to restrict or validate user input as it is edited. The predicate is called on every proposed text change; returning `false` will block the change.
    ///
    /// - Parameter predicate: A closure that takes the proposed `String` and returns `true` (allow) or `false` (block).
    /// - Returns: A modified view with the environment value set.
    ///
    /// Example:
    /// ```swift
    /// VTextField(text: $digits, placeholder: "Digits")
    ///     .contentValidation { $0.allSatisfy(\ .isNumber) }
    /// ```
    ///
    /// __Platform:__ iOS, iPadOS
    public func contentValidation(_ predicate: @escaping (String) -> Bool) -> some View {
        self.environment(\.tfContentValidation, predicate)
    }
}
