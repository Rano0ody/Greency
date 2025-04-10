//
//  GreencyApp.swift
//  Greency
//
//  Created by Rand abdullatif on 11/10/1446 AH.
//

import SwiftUI
import GoogleMaps

@main
struct GreencyApp: App {
    init() {
        GMSServices.provideAPIKey("AIzaSyCkoa1x8uEh6wT-u3mL6vQxzy_arIoE468")
    }

    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}
