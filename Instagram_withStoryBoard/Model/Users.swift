
import Foundation

class Users {
    var email: String?
    var profile_image: String?
    var username: String?
    var id: String?
}

extension Users {
    static func transformUser(dictionary: NSDictionary, userId: String) -> Users {
        let user = Users()
        user.email = dictionary["email"] as? String
        user.profile_image = dictionary["profile_image"] as? String
        user.username = dictionary["username"] as? String
        user.id = userId
        return user
    }
}
