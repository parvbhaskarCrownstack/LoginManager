//
//  ViewController.swift
//  loginApp
//
//  Created by Parv Bhaskar on 26/02/21.
//

import UIKit

class ViewController: UIViewController {
    
    lazy var stackVew: UIStackView = {
        let sv = UIStackView()
        sv.distribution = .fillEqually
        sv.axis = .vertical
        sv.spacing = 20
        
        sv.translatesAutoresizingMaskIntoConstraints = false

        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupView()
        FacebookManager.sharedManager().logout()
        if FacebookManager.sharedManager().isUserSignedIn() {
            let vc = HomeScreen()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
        if GoogleManager.shared.isUserSignedIn() {
            let vc = HomeScreen()
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func setupView() {
        self.view.addSubview(stackVew)
        setupAppleSignInButton()

        setupStackViewConstraints()
        
        let facebookButton = UIButton()
        facebookButton.setTitle("Facebook Login", for: .normal)
        facebookButton.backgroundColor = .blue
        facebookButton.addTarget(self, action: #selector(facebookLoginClicked), for: .touchUpInside)
        
        self.stackVew.addArrangedSubview(facebookButton)
        
        let googleButton = UIButton()
        googleButton.setTitle("Google Login", for: .normal)
        googleButton.backgroundColor = .red
        googleButton.addTarget(self, action: #selector(googleLoginClicked), for: .touchUpInside)
        
        self.stackVew.addArrangedSubview(googleButton)
    }
    
    func setupStackViewConstraints() {
        stackVew.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackVew.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        stackVew.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
        
        stackVew.arrangedSubviews[0].heightAnchor.constraint(equalToConstant: 50).isActive = true
    }

    func setupAppleSignInButton() {
        let appleLogin = AppleLoginManager(delegate: self)
            
        self.stackVew.addArrangedSubview(appleLogin.createAppleLoginButton())
    }
    
    @objc func facebookLoginClicked() {
        FacebookManager.sharedManager().loginFromController(self) { (user, error) in
            if error != nil {

            } else if user != nil {

            }
        }
    }
    
    @objc func googleLoginClicked() {
        GoogleManager.shared.loginFromController(self) { (user, error) in
            if error != nil {

            } else if user != nil {

            }
        }
    }
}

extension ViewController: AppleLoginDelegate {
    func didCompleteWithAuthorization(responseModel: AppleLoginManager.AppleLoginResponseModel) {
        print(responseModel)
    }
}

