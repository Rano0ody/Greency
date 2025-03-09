import SwiftUI

struct InputField: View {
    var label: String
    @Binding var text: String
    var placeholder: String
    var isSecure: Bool = false
    var isEmail: Bool = false

    var body: some View {
        VStack(alignment: .leading) {
            Text(label)
                .font(.custom("SF Pro Display", size: 20).weight(.semibold))
            
            if isSecure {
                SecureField(placeholder, text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 5)
            } else {
                TextField(placeholder, text: $text)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.top, 5)
                    .keyboardType(isEmail ? .emailAddress : .default)
            }
        }
        .padding(.horizontal, 24)
    }
}
#Preview {
    
}