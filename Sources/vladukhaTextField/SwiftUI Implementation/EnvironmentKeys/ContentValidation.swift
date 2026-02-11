//
//  ContentValidation.swift
//  vladukhaTextField
//
//  Created by vladukha on 11.02.2026.
//


import SwiftUI

extension EnvironmentValues {
    @Entry var tfContentValidation: (String) -> Bool = {_ in return true}
}
