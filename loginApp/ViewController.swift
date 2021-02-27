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
        sv.backgroundColor = .yellow
        sv.distribution = .fillEqually
        sv.spacing = 20
        
        sv.translatesAutoresizingMaskIntoConstraints = false

        return sv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupView()
    }
    
    func setupView() {
        self.view.addSubview(stackVew)
        setupAppleSignInButton()

        setupStackViewConstraints()
    }
    
    func setupStackViewConstraints() {
        stackVew.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        stackVew.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        stackVew.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.8).isActive = true
    }

    func setupAppleSignInButton() {
        let appleLogin = AppleLoginManager(delegate: self, presentedWindow: self)
        self.stackVew.addArrangedSubview(appleLogin.createAppleLoginButton())
    }
}

extension ViewController: AppleLoginDelegate {
    func didCompleteWithAuthorization(responseModel: AppleLoginManager.AppleLoginResponseModel) {
        print(responseModel)
    }
}
