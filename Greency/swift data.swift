import Foundation
import SwiftData

@Model
class UserData {
    var id: UUID
    var firstName: String
    var lastName: String
    var email: String
    var password: String

    init(id: UUID = UUID(), firstName: String, lastName: String, email: String, password: String) {
        self.id = id
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.password = password
    }
}
