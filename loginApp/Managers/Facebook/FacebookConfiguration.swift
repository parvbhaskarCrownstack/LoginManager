
import UIKit
import FBSDKLoginKit
import FBSDKCoreKit

class FacebookConfiguration: SocialConfiguration {

    fileprivate static var fbConfiguration: FacebookConfiguration?

    // MARK: - Permissions
    struct Permissions {
        static let PublicProfile = "public_profile"
        static let Email = "email"
        static let UserBirthday = "user_birthday"
        static let UserLocation = "user_location"
        static let UserFriends = "user_friends"
        static let UserAboutMe = "user_about_me"
        static let UserHometown = "user_hometown"
        static let UserLikes = "user_likes"
        static let UserInterests = "user_interests"
        static let UserPhotos = "user_photos"
        static let FriendsPhotos = "friends_photos"
        static let FriendsHometown = "friends_hometown"
        static let FriendsLocation = "friends_location"
        static let FriendsEducationHistory = "friends_education_history"
    }

    fileprivate class func defaultPermissions() -> [String] {
        return [Permissions.PublicProfile, Permissions.Email]
    }

    override init(client_ID: String, scope: [String]) {
        super.init(client_ID: client_ID, scope: scope)
    }

    // MARK: - Helpers
    fileprivate class func fbAppId() -> String! {
        return "262307542118472" // -> put the facebook app Id or give the configuration constant
    }

    class func defaultConfiguration() -> FacebookConfiguration {
        if fbConfiguration == nil {
            fbConfiguration = FacebookConfiguration(client_ID: fbAppId(), scope: defaultPermissions())
        }

        return fbConfiguration!
    }
}
