// Copyright (c) 2014-present, Facebook, Inc. All rights reserved.
//
// You are hereby granted a non-exclusive, worldwide, royalty-free license to use,
// copy, modify, and distribute this software in source code or binary form for use
// in connection with the web services and APIs provided by Facebook.
//
// As with any software that integrates with the Facebook platform, your use of
// this software is subject to the Facebook Developer Principles and Policies
// [http://developers.facebook.com/policy/]. This copyright notice shall be
// included in all copies or substantial portions of the software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS
// FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR
// COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER
// IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
// CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit
import AccountKit
import FBSDKCoreKit
import FBSDKLoginKit

// MARK: - LoginViewController: UIViewController

final class LoginViewController: UIViewController {
    2
    // : Declare and initialize showAccountOnAppear
    // : Declare and initialize dataEntryViewController
    // MARK: Properties
    fileprivate var accountKit = AKFAccountKit(responseType: .accessToken) // This app is "accessToken flow"(without server on app) not "authorization code flow"
    //fileprivate var authorizationCode = String()
    fileprivate var dataEntryViewController: AKFViewController? = nil
    fileprivate var showAccountOnAppear = false
    
    @IBOutlet weak var facebookButton: UIButton!
    @IBOutlet weak var surfConnectLabel: UILabel!
    
    // MARK: View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // : Set the value of showAccountOnAppear
        showAccountOnAppear = accountKit.currentAccessToken != nil
        // : Set the value of dataEntryViewController
        dataEntryViewController = accountKit.viewControllerForLoginResume() as? AKFViewController
            
        facebookButton.titleLabel?.addTextSpacing(2.0)
        surfConnectLabel.addTextSpacing(6.0)
        
        // Create the login button
//        let loginButton = FBSDKLoginButton()
//        loginButton.center = view.center
//        loginButton.delegate = self
//        view.addSubview(loginButton)
        
        // Check if user is logged in
        if ((FBSDKAccessToken.current()) != nil) {
            presentWithSegueIdentifier("showAccount", animated: false)
        }
        
        // Set read permissions
//        loginButton.readPermissions = ["public_profile"]
        
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
     // : If showAccountOnAppear is true, present the AccountViewController
        if showAccountOnAppear {
            showAccountOnAppear = false
            presentWithSegueIdentifier("showAccount", animated: animated)
        }else if let viewController = dataEntryViewController as? UIViewController { // : If showAccountOnAppear is false, prepare and present the dataEntryViewController
            present(viewController, animated: animated, completion: nil )
            dataEntryViewController = nil
        }
     
    
        self.navigationController?.isNavigationBarHidden = true
    
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    // MARK: Actions
    
    
    @IBAction func loginWithPhone(_ sender: AnyObject) {
        FBSDKAppEvents.logEvent("loginWithPhone clicked")
        if let viewController = accountKit.viewControllerForPhoneLogin() as? AKFViewController {
        prepareDataEntryViewController(viewController)
        if let viewController = viewController as? UIViewController {
            present(viewController, animated: true, completion: nil)
            }
        }
    }
    // : Add the IBAction, loginWithEmail(_ sender: )
        @IBAction func loginWithEmail(_ sender: AnyObject) {
            FBSDKAppEvents.logEvent("loginWithEmail clicked")
            if let viewController = accountKit.viewControllerForEmailLogin() as? AKFViewController {
                prepareDataEntryViewController(viewController)
                if let viewController = viewController as? UIViewController {
                    present(viewController, animated: true, completion: nil)
                }
            }
        }
    
    @IBAction func loginWithFacebook(_ sender: Any) {
        let readPermissions = ["public_profile"]
        let loginManager = FBSDKLoginManager()
        loginManager.logIn(withReadPermissions: readPermissions, from: self) { (result, error) in
            if ((error) != nil){
                print("login failed with error: \(String(describing: error))")
            } else if (result?.isCancelled)! {
                print("login cancelled")
            } else {
                //present the account view controller
                self.presentWithSegueIdentifier("showAccount",animated: true)
            }
        }
    }

    // MARK: Helper Methods
    
    // : Add the helper method, prepareDataEntryViewController
    func prepareDataEntryViewController(_ viewController: AKFViewController){
        viewController.delegate = self
        /*
        // Basic UI Customization
        
        // Classic skin with no background image
        viewController.uiManager = AKFSkinManager.init(skinType:
            AKFSkinType.classic, primaryColor: UIColor.green)*/
        viewController.uiManager = AKFSkinManager.init(skinType:
            AKFSkinType.classic, primaryColor: UIColor.init(red: 0, green: 128/255, blue: 128/255, alpha: 1),
                                 backgroundImage: #imageLiteral(resourceName: "SS_SurfMafia"),
                                 backgroundTint: AKFBackgroundTint.black, tintIntensity: 0.55)
    }
    // : Add the helper method, presentWithSegueIdentifier
    fileprivate func presentWithSegueIdentifier(_ segueIdentifier: String, animated: Bool) {
        if animated {
            performSegue(withIdentifier: segueIdentifier, sender: nil)
        } else {
            UIView.performWithoutAnimation {
                self.performSegue(withIdentifier: segueIdentifier, sender: nil)
            }
        }
    }
   
}

// MARK: - LoginViewController: FBSDKLoginButtonDelegate
extension LoginViewController: FBSDKLoginButtonDelegate {
    
    public func loginButton(_ loginButton: FBSDKLoginButton!, didCompleteWith
        result: FBSDKLoginManagerLoginResult!, error: Error!) {
        if let error = error {
            print("Login failed with error: \(error)")
        }
        
        // The FBSDKAccessToken is expected to be available, so we can navigate
        // to the account view controller
        if result.token != nil {
            presentWithSegueIdentifier("showAccount", animated: true)
        }
    }
    
    public func loginButtonDidLogOut(_ loginButton: FBSDKLoginButton!) {
        // On logout, we just remain on the login view controller
    }
}

// MARK: - LoginViewController: AKFViewControllerDelegate

    // : Add the AKFViewControllerDelegate as an extension
extension LoginViewController : AKFViewControllerDelegate {
    // : Handle callback on successful login
    func viewController(_ viewController: UIViewController!, didCompleteLoginWith accessToken: AKFAccessToken!, state: String!) {
        //self.authorizationCode = authorizationCode
        presentWithSegueIdentifier("showAccount", animated: false)
    }
    // : Handle callback on failed login.
    func viewController(_ viewController: UIViewController!, didFailWithError error: Error!) {
        print ("\(viewController) did fail with error \(error)")
    }
}



/*
 Step 5b. Your app’s server requests an access token from Account Kit using the authorization code
 
 If you are using the authorization code you’ll need to implement the calls from your server to the Graph API. The request for a short-lived access token looks like this:
 
 GET https://graph.accountkit.com/v1.1/access_token?grant_type=authorization_code
 &code=<authorization_code>&access_token=AA|<facebook_app_id>|<app_secret>
 The response will look like this:
 
 {
 "id" : <account_kit_user_id>,
 "access_token" : <account_access_token>,
 "token_refresh_interval_sec" : <refresh_interval>
 }
 Step 5c. Your app’s server requests an account object using the access token. The request for an account looks like this:
 
 GET https://graph.accountkit.com/v1.1/me/?access_token=<access_token>
 And the response will look like this:
 
 {
 "id":"12345",
 "phone":{
 "number":"+15551234567"
 "country_prefix": "1",
 "national_number": "5551234567"
 }
 }
 Step 6. Access Account Information
 
 Since the account request is happening server side you won’t be calling requestAccount() from the accountKit object. This is great, because this takes the access token out of the equation. The access token never has to be passed from server to client (and it should not be).
 
 Instead you’ll be populating the data fields of the AccountViewController with the account object returned by your server, which could look something like this:
 
 self.requestAccountFromAppServer { [weak self] (account, error) in
 if let error = error {
 self?.accountIDLabel.text = "N/A"
 self?.titleLabel.text = "Error"
 self?.valueLabel.text = error.localizedDescription
 } else {
 self?.accountIDLabel.text = account?.accountID
 
 if let emailAddress = account?.emailAddress, emailAddress.characters.
 count > 0 {
 self?.titleLabel.text = "Email Address"
 self?.valueLabel.text = emailAddress
 } else if let phoneNumber = account?.phoneNumber {
 self?.titleLabel.text = "Phone Number"
 self?.valueLabel.text = phoneNumber.stringRepresentation()
 }
 }
 }
 }
 */
