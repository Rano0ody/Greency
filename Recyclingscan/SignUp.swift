//
//  SignUp.swift
//  Greency
//
//  Created by Rand abdullatif on 03/09/1446 AH.
//

import SwiftUI
import FirebaseAuth



struct SignUpView: View {
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var navigateToLogin = false
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 15) {
                Text("Welcome")
                    .font(.system(size: 50, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 50)

                Text("Good Evening")
                    .font(.custom("SF Pro Display", size: 25).weight(.regular))
                    .frame(maxWidth: .infinity, alignment: .center)

                // First Name
                InputField(label: "First Name", text: $firstName, placeholder: "Enter your first name")

                // Last Name
                InputField(label: "Last Name", text: $lastName, placeholder: "Enter your last name")

                // Email
                InputField(label: "Email", text: $email, placeholder: "Enter your email", isEmail: true)

                // Password
                InputField(label: "Password", text: $password, placeholder: "Enter your password", isSecure: true)

                // Show error message if any
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal, 24)
                }

                // Sign Up Button
                Button(action: signUp) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)

                Spacer()

                // Log In Section
                HStack {
                    Text("Already have an account?")
                        .font(.caption)
                        .foregroundColor(.gray)

                    NavigationLink(destination: LogInView(), isActive: $navigateToLogin) {
                        Text("Log In")
                            .font(.caption)
                            .fontWeight(.bold)
                            .foregroundColor(.blue)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.bottom, 120)
            }
            .onTapGesture {
                hideKeyboard()
            }
        }
    }

    func signUp() {
        Auth.auth().createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                errorMessage = error.localizedDescription
            } else {
                navigateToLogin = true
            }
        }
    }
}

#Preview {
    SignUpView()
}




