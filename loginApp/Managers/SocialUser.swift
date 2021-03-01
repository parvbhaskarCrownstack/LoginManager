
import UIKit

struct SocialAccount {
    static let FACEBOOK = "Facebook"
    static let GOOGLE = "Google"
}

class SocialUser {

    var accountID: String!
    var accountType: String!
    var accessToken: String?
    var name: String?
    var firstName: String?
    var lastName: String?
    var email: String?
    var profilePicture: String?
    var ageRange: Int?
}
