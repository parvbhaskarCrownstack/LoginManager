## Social Login

# Apple login
 There are few steps to integrate apple login into the application
 - Enable "Sign In with Apple" in the capability section
   - Open your Xcode Project.
   - Project Navigator→ Select Project → Select Target
   - In Project Editor, Click Signing & Capabilities
   - Add Capability by clicking the + button. Search for Sign In with Apple Capability in Capability Library
   - Double-click the capability to add
 - Add "AppleLoginManager.swift" into your project
 - Initialize the manager class and get the apple singin button to add on UI
    ```sh
    let appleLogin = AppleLoginManager(delegate: self, presentedWindow: self)
     self.stackVew.addArrangedSubview(appleLogin.createAppleLoginButton())
    ```
- Also enable the delegate support by extending to AppleLoginDelegate protocol, and support for the incoming result function
    ```sh
    > func didCompleteWithAuthorization(responseModel: AppleLoginManager.AppleLoginResponseModel) {
        print(responseModel)
    }
    ```


