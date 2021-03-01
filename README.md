# Social Login

### Apple login
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
    func didCompleteWithAuthorization(responseModel: AppleLoginManager.AppleLoginResponseModel) {
        print(responseModel)
    }
    ```

### Facebook login
Before integrating facebook login, first you need to create and app on facebok developer portal.

There are few steps to integrate it in code.
- install pod 'FBSDKLoginKit' into your project
- add required keys into the info.plist file
- Add the following code into AppDelegate's didFinishLaunchingWithOptions function to initialize facebook sdk.
    ```sh
    ApplicationDelegate.shared.application(application, didFinishLaunchingWithOptions: launchOptions)
    ```
- put following function into Appdelegate to handle the fallback
    ```sh
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        ApplicationDelegate.shared.application(
            app,
            open: url,
            sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
            annotation: options[UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    ```
- If you ae using SceneDelegate then you also need to put follwing code into SceneDelegate class
    ```sh
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else {
            return
        }

        ApplicationDelegate.shared.application(
            UIApplication.shared,
            open: url,
            sourceApplication: nil,
            annotation: [UIApplication.OpenURLOptionsKey.annotation]
        )
    }
    ```
- Drag and drop the facebook manager and other helper classes
- Add facebook key into the "fbAppId" function of FacebookConfiguration class.
- Create a custom facebook button add the following code on its IBAction
    ```sh
        FacebookManager.sharedManager().loginFromController(self) { (user, error) in
            if error != nil {
                // Handle Error
            } else if user != nil {
                // Handle Success
            }
        }
   ```
    this  funtion has a call back which will return error incase of process cancel and will return user infocation in case of successful login.
- if you want to check if the user is already logged in or not, you can check it with the following code
    ```sh
        if FacebookManager.sharedManager().isUserSignedIn() {
            // User is logged in
        }
    ```
- User can be logged out using the follwing code 
    ```sh
        FacebookManager.sharedManager().logout()
    ```
    
### Google Login
To integrate google login you first need to create an app at google console and get the created google client id.

Steps to integrate it in the project
- install pod GoogleSignIn
- Add GoogleManager and related helper fils into the project
- Add client id into the "clientId" function of GoogleManager class.
- Add the following line of code into the AppDelegate file
    ```sh
        GoogleManager.initializeGoogleSdkWithClientId()
    ```
- Now set up a URL type to handle the callback, In your Xcode project's Info tab, under the URL Types section, find the URL Schemes box containing the string YOUR_REVERSED_CLIENT_ID. Replace this string with your reversed client ID—your client ID with the order of the dot-delimited fields reversed, 
for example
    ```sh
        client id = 1212121212121212-v4q27ndrl2acs4ahrw5u4mpb9lb89i6i.apps.googleusercontent.com
        can be changed to
        client id = com.googleusercontent.apps.1212121212121212-v4q27ndrl2acs4cbos5u4mpb9lb89i6i
    ```
- Create a custom Google SingIn button add the following code on its IBAction
    ```sh
        GoogleManager.sharedManager().loginFromController(self) { (user, error) in
            if error != nil {
                // Handle Error
            } else if user != nil {
                // Handle Success
            }
        }
   ```
    this  funtion has a call back which will return error incase of process cancel and will return user infocation in case of successful login.
- if you want to check if the user is already logged in or not, you can check it with the following code
    ```sh
        if GoogleManager.shared.isUserSignedIn() {
            // User is logged in
        }
    ```
- User can be logged out using the follwing code 
    ```sh
        GoogleManager.sharedManager().logout()
    ```


