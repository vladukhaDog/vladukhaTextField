//
//  DoneButtonModifier.swift
//  vladukhaTextField
//
//  Created by vladukha on 11.02.2026.
//

import SwiftUI

extension View {
    /// Controls whether a toolbar Done button is shown above the keyboard for a VTextField.
    ///
    /// When enabled, this adds a Done button above the keyboard to allow easy dismissal. Particularly useful for number pads and custom keyboards.
    ///
    /// - Parameter enabled: Pass `true` to show a Done button, or `false` to omit it.
    /// - Returns: A modified view with the environment value set.
    ///
    /// Example:
    /// ```swift
    /// VTextField(text: $pin, placeholder: "PIN")
    ///     .doneButton(true)
    /// ```
    ///
    /// __Platform:__ iOS, iPadOS
    public func doneButton(_ enabled: Bool) -> some View {
        self.environment(\.tfDoneButton, enabled)
    }
}
