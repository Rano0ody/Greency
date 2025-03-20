//
//  RecyclingscanApp.swift
//  Recyclingscan
//
//  Created by Rand abdullatif on 26/08/1446 AH.
//

// import SwiftUI

// @main
// struct RecyclingscanApp: App {
 //  var body: some Scene {
  //      WindowGroup {
   //         ContentView()
   //     }
   // }
// }
import SwiftUI
import Firebase

@main
struct GreencyApp: App {  // Make sure your app struct is correct
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            SignUpView()  // Ensure this is your initial view
        }
    }
}

struct MyApp: App {
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}
 
