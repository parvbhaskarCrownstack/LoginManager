
import UIKit
import FBSDKLoginKit

class FacebookManager: SocialManager, Social {

    fileprivate static var manager = FacebookManager()
    var configuration: FacebookConfiguration = FacebookConfiguration.defaultConfiguration()

    fileprivate override init() {
        super.init()

        // customize initialization
    }

    // MARK: - Singleton Instance
    /**
     Initializes FacebookManager class to have a new instance of manager

     - parameter config: requires a FacebookConfiguration instance which is required to configure the manager

     - returns: an instance of FacebookManager which can be accessed via sharedManager()
     */
    class func managerWithConfiguration(_ config: FacebookConfiguration!) -> FacebookManager {

        if config != nil {
            manager.configuration = config!
            manager.configuration.isConfigured = true
        }
        return manager
    }

    class func sharedManager() -> FacebookManager {
        if isManagerConfigured() == false {
            _ = managerWithConfiguration(FacebookConfiguration.defaultConfiguration())
        }
        return manager
    }

    // MARK: - Helpers for Manager
    fileprivate class func isManagerConfigured() -> Bool {
        return self.manager.configuration.isConfigured
    }

    class func resetManager() {
        self.manager.configuration.isConfigured = false
    }

    // MARK: - Token
    class func token() -> AccessToken? {
        return AccessToken.current
    }

    func tokenString() -> String? {
        if let token = AccessToken.current?.tokenString {
            return token
        }
        return nil
    }

    func isTokenValid() -> Bool {
        if let _ = AccessToken.current {
            return true
        } else {
            return false
        }
    }

    func isUserSignedIn() -> Bool {
        if let token = AccessToken.current, !token.isExpired {
            return true
        }
        else {
            return false
        }
    }
    
    // MARK: Profile
    func currentProfile() -> Profile {
        return Profile.current!
    }

    func currentProfileURL() -> URL {
        return (Profile.current?.imageURL(forMode: Profile.PictureMode.square, size: CGSize(width: 100, height: 100)))!
    }

    func logout() {
        super.logOut()
        LoginManager().logOut()

        // flush permissions
        configuration.permissions = []
    }
    
    fileprivate func loginWithFacebookSDK() {
        FacebookManager.sharedManager().logout()
        LoginManager().logIn(permissions: configuration.permissions, from: fromController, handler: { (result, error) in

            if error != nil {
                // According to Facebook:
                // Errors will rarely occur in the typical login flow because the login dialog
                // presented by Facebook via single sign on will guide the users to resolve any errors.
                LoginManager().logOut()
                self.socialCompletionHandler?(nil, error)
            } else if let resultFacebook: LoginManagerLoginResult = result {
                if resultFacebook.isCancelled {

                    // Handle cancellations
                    LoginManager().logOut()
                    self.socialCompletionHandler?(nil, error)

                } else {
                    self.fetchProfileInfo(nil)
                }
            }
        })
    }

    //
    // MARK: - Login
    //

    /**
     Wrapper method to provide Facebook Login

     - parameter fromController: source view controller from which login should be prompted.
     - parameter handler:        return with SocialCompletionHandler, either valid social user or with error information
     */
    override func loginFromController(_ sourceController: UIViewController, Handler handler: SocialCompletionHandler? = nil) {
        super.loginFromController(sourceController, Handler: handler)

        self.loginWithFacebookSDK()
    }

    //
    // MARK: - Profile Info
    //

    /**
     Returns user facebook profile information

     - parameter completion: gets callback once facebook server gives response
     */
    override func fetchProfileInfo(_ completion: SocialCompletionHandler?) {
        // See link for more fields:
        // http://stackoverflow.com/questions/32031677/facebook-graph-api-get-request-should-contain-fields-parameter-swift-faceb

        if completion != nil {
            self.socialCompletionHandler = completion
        }

        let request: GraphRequest = GraphRequest(graphPath: "me", parameters: ["fields": "id, email, name, first_name, last_name, gender, picture.width(400).height(400), age_range"], httpMethod: HTTPMethod(rawValue: "GET"))
        request.start { (connection, result, error) -> Void in

            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
                if let error = error { // handle error
                    self.logout()

                    self.socialCompletionHandler?(nil, NSError(domain: "Error", code: 201, userInfo: ["info": error.localizedDescription]))
                }
                else {
                    if let userInfo: NSDictionary = result as? NSDictionary {
                        self.extractDataFromResponseReceived(userInfo: userInfo)
                    } else {
                        self.socialCompletionHandler?(nil, NSError(domain: "Error", code: 201, userInfo: ["info": "Invalid data received"]))
                    }
                }
            })
        }
    }

    private func extractDataFromResponseReceived(userInfo: NSDictionary) {
        let socialUser = SocialUser()
        socialUser.accountType = SocialAccount.FACEBOOK
        
        if let token = tokenString() {
            socialUser.accessToken = token
        } else {
            return
        }

        guard let accountId: String = userInfo["id"] as? String else {
            return
        }
        
        socialUser.accountID = accountId
        socialUser.name = userInfo["name"] as? String
        socialUser.firstName = userInfo["first_name"] as? String
        socialUser.lastName = userInfo["last_name"] as? String
        socialUser.email = userInfo["email"] as? String
        socialUser.profilePicture = userInfo.value(forKeyPath: "picture.data.url") as? String

        if let ageDictionary: NSDictionary = userInfo.value(forKeyPath: "age_range") as? NSDictionary, let minAge: Int = ageDictionary.value(forKeyPath: "min") as? Int {
            socialUser.ageRange = minAge
        }
        
        self.socialCompletionHandler?(socialUser, nil)
    }
}
