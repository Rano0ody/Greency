//
//  profileView.swift
//  Greency
//
//  Created by joody on 12/10/1446 AH.
//
import SwiftUI
import SwiftData
import PhotosUI

struct profileView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var context
    @Query private var users: [UserData]

    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @State private var userName: String = "Username"
    @State private var isEditing: Bool = false
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var profileImage: UIImage?
    @State private var navigateToLogin: Bool = false
    @State private var navigateToHome: Bool = false


    var body: some View {
       NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                NavigationLink(destination: HomePageView(), isActive: $navigateToHome) {
                    EmptyView()
                }

                if isEditing {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        if let profileImage {
                            Image(uiImage: profileImage)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100 , height: 100)
                                .clipShape(Circle())
                        } else {
                            Image("profileImage")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 100 , height: 100)
                                .clipShape(Circle())
                        }
                    }
                    .onChange(of: selectedItem) { newItem in
                        Task {
                            if let data = try? await newItem?.loadTransferable(type: Data.self),
                               let uiImage = UIImage(data: data) {
                                profileImage = uiImage
                            }
                        }
                    }
                } else {
                    if let profileImage {
                        Image(uiImage: profileImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100 , height: 100)
                            .clipShape(Circle())
                    } else {
                        Image("profileImage")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 100 , height: 100)
                            .clipShape(Circle())
                    }
                }
              


                if isEditing {
                    TextField("Username", text: $userName)
                        .font(.custom("SF Pro", size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding()
                        .cornerRadius(10)
                        .disableAutocorrection(true)
                        .keyboardType(.asciiCapable)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 50)
                } else {
                    Text(userName)
                        .font(.custom("SF Pro", size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding(.bottom, 50)
                }

                
                VStack(spacing: 25) {
                    ProfileField(icon: "envelope", text: $email, isSecure: false, isEditing: isEditing)
                    ProfileField(icon: "lock", text: $password, isSecure: true, isEditing: isEditing)
                }
                .padding(.horizontal, 20)
                NavigationLink(destination: SignUpView(), isActive: $navigateToLogin) {
                    EmptyView()
                }

                Button(action: logout) {
                    HStack {
                        Text("Logout")
                            .foregroundColor(Color(hex: "FF4C4C"))
                            .font(.custom("SF Pro", size: 22))
                            .fontWeight(.bold)
                        Image(systemName: "arrow.right.square")
                            .foregroundColor(Color(hex: "FF4C4C"))
                    }
                }
                .padding(.top, 30)

                Spacer()
            }
            .navigationBarTitle("Profile Page", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        navigateToHome = true
                    }) {
                        Text("Back")
                            .foregroundColor(Color(hex: "007AFF"))
                            .font(.custom("SF Pro", size: 18))
                    }
                }


                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isEditing.toggle()
                        if !isEditing {
                            saveChanges()
                        }
                    }) {
                        Text(isEditing ? "Save" : "Edit")
                            .foregroundColor(Color(hex: "007AFF"))
                            .font(.custom("SF Pro", size: 18))
                    }
                }
            }
            .navigationBarBackButtonHidden(true)
            .onAppear {
                loadUserData()
            }
        }
    }

    // ✅ تحميل بيانات المستخدم المحفوظة أو إنشاء واحد جديد لو ما فيه
    func loadUserData() {
        if let currentUser = users.first {
            userName = currentUser.firstName + " " + currentUser.lastName
            email = currentUser.email
            password = currentUser.password
        } else {
            let newUser = UserData(firstName: "", lastName: "", email: "", password: "")
            context.insert(newUser)
            do {
                try context.save()
                print("✅ تم إنشاء مستخدم جديد")
            } catch {
                print("❌ فشل في إنشاء المستخدم: \(error)")
            }
        }
    }

    // ✅ حفظ التعديلات
    func saveChanges() {
        guard let currentUser = users.first else { return }

        let nameParts = userName.split(separator: " ", maxSplits: 1)
        currentUser.firstName = nameParts.first.map(String.init) ?? ""
        currentUser.lastName = nameParts.dropFirst().first.map(String.init) ?? ""
        currentUser.email = email
        currentUser.password = password

        do {
            try context.save()
            print("✅ تم حفظ التغييرات بنجاح")
        } catch {
            print("❌ فشل في حفظ التغييرات: \(error)")
        }
    }

    func logout() {
        email = ""
        password = ""
        userName = "Username"
        isEditing = false
        navigateToLogin = true
    }

}

// الحقول
struct ProfileField: View {
    var icon: String
    @Binding var text: String
    var isSecure: Bool
    var isEditing: Bool

    var body: some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 25))
                .foregroundColor(Color(hex: "70CB00"))
                .frame(width: 30, height: 30)

            if isSecure {
                if isEditing {
                    TextField("Password", text: $text)
                        .foregroundColor(.black)
                        .font(.custom("SF Pro", size: 18))
                        .disableAutocorrection(true)
                        .keyboardType(.asciiCapable)
                } else {
                    SecureField("Password", text: $text)
                        .disabled(true)
                        .foregroundColor(.black)
                        .font(.custom("SF Pro", size: 18))
                }
            } else {
                TextField("", text: $text)
                    .disabled(!isEditing)
                    .foregroundColor(.black)
                    .font(.custom("SF Pro", size: 18))
                    .onChange(of: text) { newValue in
                        text = newValue.filter { $0.isNumber || $0.isLetter || $0 == "@" || $0 == "." }
                    }
                    .disableAutocorrection(true)
                    .keyboardType(.asciiCapable)
            }
        }
        .padding()
        .background(Color(hex: "F2F2F7"))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "979797"), lineWidth: 1))
        .frame(height: 50)
    }
}

// الألوان
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default: (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(.sRGB, red: Double(r) / 255, green: Double(g) / 255, blue: Double(b) / 255, opacity: Double(a) / 255)
    }
}

struct profileView_Previews: PreviewProvider {
    static var previews: some View {
        profileView()
    }
}
