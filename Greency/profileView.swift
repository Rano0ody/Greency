//
//  profileView.swift
//  Greency
//
//  Created by joody on 12/10/1446 AH.
//
import SwiftUI

struct profileView: View {
    @Environment(\.dismiss) private var dismiss  // لاستدعاء dismiss للصفحة
    @State private var email: String = "llanmi@mail.com"
    @State private var password: String = "XXXXXXXXXXXXXX"
    @State private var name: String = "Tahani Muhsen"
    @State private var userName: String = "Username" // Default text for username
    @State private var isEditing: Bool = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Spacer()
                
                // صورة البروفايل
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .foregroundColor(Color(hex: "2FC2D6"))
                    .padding(.bottom, 10)
                
                // اسم المستخدم – يظهر كنص عند عدم التعديل وعند التعديل يصبح TextField
                if isEditing {
                    TextField("Username", text: $userName)
                        .font(.custom("SF Pro", size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(hex: "F2F2F7"))
                        .cornerRadius(10)
                        .disableAutocorrection(true)
                        .keyboardType(.asciiCapable)
                } else {
                    Text(userName)
                        .font(.custom("SF Pro", size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(.gray)
                }
                
                // حقول الإيميل والباسوورد مع مسافة بينهم
                VStack(spacing: 25) {
                    ProfileField(icon: "envelope.fill", text: $email, isSecure: false, isEditing: isEditing)
                    ProfileField(icon: "lock.fill", text: $password, isSecure: true, isEditing: isEditing)
                }
                .padding(.horizontal, 20)
                
                // زر تسجيل الخروج
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
                // زر الـ Back المُعدل: عند الضغط يُغلق الصفحة (يستخدم dismiss)
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Text("Back")
                            .foregroundColor(Color(hex: "007AFF"))
                            .font(.custom("SF Pro", size: 18))
                    }
                }
                // زر "Edit" أو "Save"
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isEditing.toggle()
                        if !isEditing {
                            // حفظ التغييرات هنا
                            saveChanges()
                        }
                    }) {
                        Text(isEditing ? "Save" : "Edit")
                            .foregroundColor(Color(hex: "007AFF"))
                            .font(.custom("SF Pro", size: 18))
                    }
                }
            }
        }
    }
    
    // حفظ التغييرات (يمكنك تعديل منطق الحفظ كما تفضلي)
    func saveChanges() {
        // إضافة كود التحديث وحفظ البيانات هنا
        print("Saving changes for user: \(userName)")
    }
    
    // تسجيل الخروج (يمكنك تعديل منطق تسجيل الخروج لاحقاً)
    func logout() {
        // إعادة تعيين الحقول أو إضافة منطق تسجيل الخروج
        email = "llanmi@mail.com"
        password = "XXXXXXXXXXXXXX"
        userName = "Username"
        isEditing = false
    }
}

// مكون لإدخال البيانات مع أيقونة
struct ProfileField: View {
    var icon: String
    @Binding var text: String
    var isSecure: Bool
    var isEditing: Bool
    
    var body: some View {
        HStack {
            Image(systemName: icon)
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

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

struct profileView_Previews: PreviewProvider {
    static var previews: some View {
        profileView()
    }
}
