//
//  SplashScreenView.swift
//  Greency
//
//  Created by bayan alshammri on 09/04/2025.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var logoVisible = false // حالة للتحكم في ظهور اللوجو تدريجياً

    var body: some View {
        ZStack {
            // تعيين لون الخلفية المحدد
            Color(red: 47/255, green: 194/255, blue: 214/255)
                .edgesIgnoringSafeArea(.all)

            VStack {
                Image("app_logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 324, height: 324)
                    .opacity(logoVisible ? 1 : 0) // ظهور تدريجي
                    .scaleEffect(logoVisible ? 1 : 0.8) // تكبير تدريجي
                    .animation(.easeIn(duration: 1), value: logoVisible)

          .opacity(logoVisible ? 1 : 0) // تأثير الظهور التدريجي
                    .animation(.easeIn(duration: 1.5), value: logoVisible)
            }
        }
        .onAppear {
            // تشغيل تأثير ظهور اللوجو بعد قليل عند تشغيل التطبيق
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                logoVisible = true
            }
            
            // تأخير الانتقال إلى صفحة تسجيل الدخول بعد 4 ثوانٍ
            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                withAnimation {
                    isActive = true
                }
            }
        }
        // بعد انتهاء مدة العرض، يتم الانتقال إلى صفحة تسجيل الدخول
        .fullScreenCover(isPresented: $isActive) {
            SignUpView()
        }
    }
}

#Preview {
    SplashScreenView()
}
