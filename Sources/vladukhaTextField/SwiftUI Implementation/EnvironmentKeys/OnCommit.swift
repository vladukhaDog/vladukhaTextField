//
//  OnCommit.swift
//  vladukhaTextField
//
//  Created by vladukha on 11.02.2026.
//


import SwiftUI

extension EnvironmentValues {
    @Entry var tfOnCommit: () -> Void = {}
}
