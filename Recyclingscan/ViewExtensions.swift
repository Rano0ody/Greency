//
//  ViewExtensions.swift
//  Greency
//
//  Created by Rand abdullatif on 03/09/1446 AH.
//


import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
