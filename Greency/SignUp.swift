import SwiftUI
import SwiftData

struct SignUpView: View {
    @Environment(\.modelContext) private var context
    @AppStorage("loggedInEmail") var loggedInEmail: String = ""
    
    @State private var firstName = ""
    @State private var lastName = ""
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
                    .padding(.bottom, 30)
                
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
                        .background(isFormValid ? Color.green : Color.gray)
                        .cornerRadius(10)
                }
                .disabled(!isFormValid)
                .padding(.horizontal, 24)
                .padding(.top, 20)
                
                NavigationLink(destination: HomePageView(), isActive: $navigateToHome) {
                    EmptyView()
                }
                .hidden()
                                
                HStack {
                    Text("Already have an account?")
                        .font(.caption)
                        .foregroundColor(.gray)
                    
                    NavigationLink(destination: LogInView()) {
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
            .navigationBarBackButtonHidden(true) // ← Hide back button here
        }
    }

    var isFormValid: Bool {
        !firstName.isEmpty &&
        !lastName.isEmpty &&
        isValidEmail(email) &&
        password.count >= 6
    }

    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegEx).evaluate(with: email)
    }

    func signUp() {
        guard isFormValid else {
            errorMessage = "Please fill all fields correctly."
            return
        }

        let descriptor = FetchDescriptor<UserData>(predicate: #Predicate { $0.email == email })

        Task {
            do {
                let results = try await context.fetch(descriptor)
                if !results.isEmpty {
                    errorMessage = "An account with this email already exists."
                    return
                }
                
                let newUser = UserData(firstName: firstName, lastName: lastName, email: email, password: password)
                context.insert(newUser)
                try context.save()
                
                DispatchQueue.main.async {
                    loggedInEmail = email
                    navigateToHome = true
                }
            } catch {
                errorMessage = "Something went wrong. Please try again."
            }
        }
    }

    private func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

#Preview {
    SignUpView()
}
