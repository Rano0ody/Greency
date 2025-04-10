//
//  profileView.swift
//  Greency
//
//  Created by joody on 12/10/1446 AH.
//

import SwiftUI

struct profileView: View {
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
                
                // اسم المستخدم - يظهر كـ Text عند عدم التعديل وعند التعديل يصبح قابل للتعديل
                if isEditing {
                    TextField("Username", text: $userName)
                        .font(.custom("SF Pro", size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(.black)
                        .padding()
                        .background(Color(hex: "F2F2F7"))
                        .cornerRadius(10)
                        .onChange(of: userName) { newValue in
                            // التأكد من أن النص بالإنجليزي فقط
                            userName = newValue.filter { $0.isNumber || $0.isLetter }
                        }
                        .disableAutocorrection(true) // تعطيل التصحيح التلقائي
                        .keyboardType(.asciiCapable) // تأكد من أن الكيبورد يتعامل مع النصوص الإنجليزية فقط
                } else {
                    Text(userName)
                        .font(.custom("SF Pro", size: 22))
                        .fontWeight(.bold)
                        .foregroundColor(isEditing ? .black : Color.gray) // يظهر بالرمادي عندما لا يكون في وضع التعديل
                }
                
                // حقول الإيميل والباسوورد مع المسافة بينهما
                VStack(spacing: 25) {  // زيادة المسافة بين الحقول
                    ProfileField(icon: "envelope.fill", text: $email, isSecure: false, isEditing: isEditing)
                    ProfileField(icon: "lock.fill", text: $password, isSecure: true, isEditing: isEditing)
                }
                .padding(.horizontal, 20)
                
                // زر تسجيل الخروج مع تكبير الكلمة
                Button(action: logout) {
                    HStack {
                        Text("Logout")
                            .foregroundColor(Color(hex: "FF4C4C"))
                            .font(.custom("SF Pro", size: 22)) // تكبير كلمة "Logout"
                            .fontWeight(.bold)
                        Image(systemName: "arrow.right.square")
                            .foregroundColor(Color(hex: "FF4C4C"))
                    }
                }
                .padding(.top, 30)  // زيادة المسافة فوق زر logout
                
                Spacer()
            }
            .navigationBarTitle("Profile Page", displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) {
                        Text("Back")
                            .foregroundColor(Color(hex: "007AFF"))
                            .font(.custom("SF Pro", size: 18)) // استخدم خط SF Pro
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isEditing.toggle()
                        if !isEditing {
                            // حفظ التغييرات عند الضغط على "Save"
                            saveChanges()
                        }
                    }) {
                        Text(isEditing ? "Save" : "Edit") // تغيير النص بين "Edit" و "Save"
                            .foregroundColor(Color(hex: "007AFF"))
                            .font(.custom("SF Pro", size: 18)) // استخدم خط SF Pro
                    }
                }
            }
        }
    }
    
    // حفظ التغييرات
    func saveChanges() {
        UserDefaults.standard.set(userName, forKey: "userName")
        UserDefaults.standard.set(email, forKey: "userEmail")
        UserDefaults.standard.set(password, forKey: "userPassword")
    }
    
    // تسجيل الخروج
    func logout() {
        // حذف بيانات المستخدم من UserDefaults
        UserDefaults.standard.removeObject(forKey: "userEmail")
        UserDefaults.standard.removeObject(forKey: "userPassword")
        UserDefaults.standard.removeObject(forKey: "userName")
        
        // إعادة تعيين الحقول إلى قيمها الافتراضية
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
                // عرض TextField بدلاً من SecureField إذا كان في وضع التعديل
                if isEditing {
                    TextField("Password", text: $text)
                        .foregroundColor(.black)
                        .font(.custom("SF Pro", size: 18)) // استخدم خط SF Pro
                        .disableAutocorrection(true)
                        .keyboardType(.asciiCapable)
                } else {
                    SecureField("Password", text: $text)
                        .disabled(true)
                        .foregroundColor(.black)
                        .font(.custom("SF Pro", size: 18)) // استخدم خط SF Pro
                }
            } else {
                TextField("", text: $text)
                    .disabled(!isEditing)
                    .foregroundColor(.black)
                    .font(.custom("SF Pro", size: 18)) // استخدم خط SF Pro
                    .onChange(of: text) { newValue in
                        // التأكد من أن النص بالإنجليزي فقط
                        text = newValue.filter { $0.isNumber || $0.isLetter || $0 == "@" || $0 == "." }
                    }
                    .disableAutocorrection(true) // تعطيل التصحيح التلقائي
                    .keyboardType(.asciiCapable) // تأكد من أن الكيبورد يتعامل مع النصوص الإنجليزية فقط
            }
        }
        .padding()
        .background(Color(hex: "F2F2F7"))
        .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color(hex: "979797"), lineWidth: 1))
        .frame(height: 50)
    }
}

// امتداد لتحويل أكواد الألوان من Hex إلى Color
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

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        profileView()
    }
}

