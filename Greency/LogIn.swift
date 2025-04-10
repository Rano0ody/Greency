import SwiftUI
import _SwiftData_SwiftUI

struct LogInView: View {
    @Environment(\.modelContext) private var context
    
    @State private var email = ""
    @State private var password = ""
    @State private var errorMessage: String?
    @State private var navigateToHome = false

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
                
                InputField(label: "Email", text: $email, placeholder: "Enter your email", isEmail: true)
                InputField(label: "Password", text: $password, placeholder: "Enter your password", isSecure: true)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal, 24)
                }
                
                Button(action: logIn) {
                    Text("Log In")
                        .frame(maxWidth: .infinity)
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.green)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                // Navigate to HomePage
                NavigationLink(destination: HomePageView(), isActive: $navigateToHome) {
                    EmptyView()
                }
                .hidden()
                
                Spacer()
                
                HStack {
                    Text("Don't have an account?")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    NavigationLink(destination: SignUpView()) {
                        Text("Sign Up")
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
    
    @Query private var users: [UserData]
    
    func logIn() {
        guard !email.isEmpty, !password.isEmpty else {
            errorMessage = "Email and password are required."
            return
        }
        
        let descriptor = FetchDescriptor<UserData>(predicate: #Predicate {
            $0.email == email && $0.password == password
        })
        
        Task {
            do {
                if let matchedUser = try await context.fetch(descriptor).first {
                    print("Welcome back, \(matchedUser.firstName)!")
                    navigateToHome = true
                } else {
                    errorMessage = "Invalid email or password."
                }
            } catch {
                errorMessage = "Something went wrong while logging in."
            }
        }
    }
}

#Preview {
    LogInView()
}
