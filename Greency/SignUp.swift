import SwiftUI
import SwiftData

struct SignUpView: View {
    @Environment(\.modelContext) private var context
    
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
                
                InputField(label: "First Name", text: $firstName, placeholder: "Enter your first name")
                InputField(label: "Last Name", text: $lastName, placeholder: "Enter your last name")
                InputField(label: "Email", text: $email, placeholder: "Enter your email", isEmail: true)
                InputField(label: "Password", text: $password, placeholder: "Enter your password", isSecure: true)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption)
                        .padding(.horizontal, 24)
                }
                
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
                
                HStack {
                    Text("Already have an account?")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    NavigationLink(destination: HomePageView(), isActive: $navigateToLogin) {
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
        // Simple validation
        guard !firstName.isEmpty, !lastName.isEmpty, !email.isEmpty, !password.isEmpty else {
            errorMessage = "All fields are required."
            return
        }
        
        // Check for duplicate email
        let descriptor = FetchDescriptor<UserData>(predicate: #Predicate { $0.email == email })
        Task {
            if let existingUser = try? await context.fetch(descriptor).first, existingUser != nil {
                errorMessage = "An account with this email already exists."
            } else {
                let newUser = UserData(firstName: firstName, lastName: lastName, email: email, password: password)
                context.insert(newUser)
                navigateToLogin = true
            }
        }
    }
}
#Preview {
    SignUpView()
}
