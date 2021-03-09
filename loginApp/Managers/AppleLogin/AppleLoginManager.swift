//
//  AppleLoginManager.swift
//  loginApp
//
//  Created by Parv Bhaskar on 26/02/21.
//

import Foundation
import AuthenticationServices

protocol AppleLoginDelegate {
    func didCompleteWithAuthorization(responseModel: AppleLoginManager.AppleLoginResponseModel)
}

class AppleLoginManager: NSObject {
    struct AppleLoginResponseModel {
        var givenName, familyName, email: String
        var identityToken: Data
        
        func getIdentityToken() -> String {
            return String(data: identityToken, encoding: .utf8) ?? ""
        }
    }
        
    private var delegate: AppleLoginDelegate
    private var presentedWindow: UIViewController
    
    init<D: AppleLoginDelegate & UIViewController>(delegate: D) {
        self.delegate = delegate
        self.presentedWindow = delegate
    }
    
    func createAppleLoginButton() -> ASAuthorizationAppleIDButton {
        let authorizationButton = ASAuthorizationAppleIDButton(type: .continue, style: .black)
        authorizationButton.addTarget(self, action: #selector(handleLogInWithAppleIDButtonPress), for: .touchUpInside)
        return authorizationButton
    }
    
    // handle Apple Signin Button action
    @objc private func handleLogInWithAppleIDButtonPress() {
        if #available(iOS 13.0, *) {
            let appleIDProvider = ASAuthorizationAppleIDProvider()
            let request = appleIDProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let authorizationController = ASAuthorizationController(authorizationRequests: [request])
            authorizationController.delegate = self
            authorizationController.presentationContextProvider = self
            authorizationController.performRequests()
        }
    }
}

extension AppleLoginManager: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    @available(iOS 13.0, *)
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.presentedWindow.view.window!
    }
    
    @available(iOS 13.0, *)
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        if let credential = authorization.credential as? ASAuthorizationAppleIDCredential {
            let responseData = AppleLoginManager.AppleLoginResponseModel(givenName: credential.fullName?.givenName ?? "", familyName: credential.fullName?.familyName ?? "", email: credential.email ?? "", identityToken: credential.identityToken ?? Data())
            self.delegate.didCompleteWithAuthorization(responseModel: responseData)
        }
    }
}
