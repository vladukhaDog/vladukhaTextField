//
//  TextContentTypeModifier.swift
//  vladukhaTextField
//
//  Created by vladukha on 11.02.2026.
//

import SwiftUI

extension View {
    /// Sets the system semantic content type for a VTextField or compatible text input.
    ///
    /// This modifier applies a suggested context (such as email, password, name, or one-time code) to the text field, enabling system features like autofill, better keyboard suggestions, and improved accessibility for the user.
    ///
    /// - Parameter contentType: The `UITextContentType` describing the expected field content (e.g., `.emailAddress`, `.password`). Pass `nil` for no hint.
    /// - Returns: A modified view with the environment value set.
    ///
    /// Use this modifier to provide the system with a hint about the kind of information expected. This improves keyboard layout, autofill, and password management integration.
    ///
    /// Example:
    /// ```swift
    /// VTextField(text: $email, placeholder: "Email")
    ///     .textContentType(.emailAddress)
    /// ```
    ///
    /// __Platform:__ iOS, iPadOS
    public func textFieldContentType(_ contentType: UITextContentType?) -> some View {
        self.environment(\.tfContentType, contentType)
    }
}
