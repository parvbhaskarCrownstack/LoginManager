//
//  GoogleManager.swift
//  loginApp
//
//  Created by Parv Bhaskar on 01/03/21.
//

import Foundation
import GoogleSignIn

class GoogleManager: SocialManager, Social {
    static var shared = GoogleManager()

    fileprivate override init() {
        super.init()

        // customize initialization
    }

    // MARK: - Helpers
    private class func clientId() -> String! {
        return "745291094545-v4q27ndrl2acs4cbos5u4mpb9lb89i6i.apps.googleusercontent.com" // -> put the Google app Id from the configuration constant
    }

    static func initializeGoogleSdkWithClientId() {
        GIDSignIn.sharedInstance().clientID = self.clientId()
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

        self.loginWithGoogleSDK()
    }
    
    //
    // MARK: - Profile Info
    //

    /**
     Returns user facebook profile information

     - parameter completion: gets callback once facebook server gives response
     */

    func logout() {
        super.logOut()
        GIDSignIn.sharedInstance()?.signOut()
    }
    
    fileprivate func loginWithGoogleSDK() {
        GoogleManager.shared.logout()

        // Start singin process
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().presentingViewController = fromController
        GIDSignIn.sharedInstance().signIn()
    }

    private func convertModelToSocialUser(user: GIDGoogleUser) {

        let socialUser = SocialUser()
        socialUser.accountType = SocialAccount.GOOGLE
        if let token = user.authentication.accessToken {
            socialUser.accessToken = token
        } else {
            return
        }

        guard let accountId: String = user.userID else {
            return
        }
        socialUser.accountID = accountId
        socialUser.name = user.profile.name
        socialUser.firstName = user.profile.givenName
        socialUser.lastName = user.profile.familyName
        socialUser.email = user.profile.email
        
        if user.profile.hasImage {
            socialUser.profilePicture = user.profile.imageURL(withDimension: 100)?.absoluteString
        }
        
        self.socialCompletionHandler?(socialUser, nil)
    }
    
    // MARK: - Token
    class func token() -> String? {
        return GIDSignIn.sharedInstance().currentUser.authentication.accessToken
    }

    func isUserSignedIn() -> Bool {
        if GIDSignIn.sharedInstance()?.hasPreviousSignIn() ?? false {
            return true
        }
        else {
            return false
        }
    }
}

extension GoogleManager: GIDSignInDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            self.socialCompletionHandler?(nil, error)
        } else {
            self.convertModelToSocialUser(user: user)
        }
    }
}
