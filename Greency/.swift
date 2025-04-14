//
//  .swift
//  Greency
//
//  Created by joody on 15/10/1446 AH.
//


  .onAppear {
        if let user = users.first {
            userName = user.userName  // تأكد أن الخاصية userName موجودة هنا
            email = user.email
            password = user.password
        }
    }

    // حفظ التغييرات في SwiftData
    func saveChanges() {
        if let user = users.first {
            user.userName = userName
            user.email = email
            user.password = password
            do {
                try user.save()
            } catch {
