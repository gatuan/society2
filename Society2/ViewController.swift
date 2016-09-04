//
//  ViewController.swift
//  Society2
//
//  Created by George Atuan on 9/3/16.
//  Copyright © 2016 George Atuan. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import FBSDKCoreKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ViewController: UIViewController {
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if NSUserDefaults.standardUserDefaults().valueForKey(KEY_UID) != nil {
            self.performSegueWithIdentifier("loggedIn", sender: nil)
        }
    }
    @IBAction func fbBtnPressed(sender: UIButton!) {
        let facebookLogin = FBSDKLoginManager()
        
        facebookLogin.logInWithReadPermissions(["email"]) { (facebookResult: FBSDKLoginManagerLoginResult!, facebookError: NSError!) -> Void in
            
            if facebookError != nil {
                print("Facebook login failed. Error \(facebookError)")
            } else {
                let accessToken = FBSDKAccessToken.currentAccessToken().tokenString
                print("Successfully logged in with facebook. \(accessToken)")
    
            }
          
            let loginButton = FBSDKLoginButton()
            
            let credential = FIRFacebookAuthProvider.credentialWithAccessToken(FBSDKAccessToken.currentAccessToken().tokenString)
            
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
            
                if error != error {
                    print("login failed \(error)")
                } else {
                    print("login successfull \(credential)")
                    NSUserDefaults.standardUserDefaults().setValue(user?.uid, forKey: KEY_UID)
                    self.performSegueWithIdentifier("loggedIn", sender: nil)
                }
            }
        }
    }
    
    @IBAction func attemptLogin(sender: AnyObject) {
        if let email = emailField.text where email != "", let pwd = passwordField.text where pwd != "" {
            
          let credential = FIREmailPasswordAuthProvider.credentialWithEmail(email, password: pwd)
            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                
            if error != nil {
                print(error)
                
                if error?.code == STATUS_WRONG_PASSWORD {
                    self.showErrorAlert("Wrong password.", msg: "Please try again")
                }
                
                if error?.code == STATUS_ACCOUNT_NONEXIST {
                    FIRAuth.auth()?.createUserWithEmail(email, password: pwd, completion: { user, error in
                    
                        if error != nil {
                            self.showErrorAlert("Could not create account", msg: "try again")
                        } else {
                            NSUserDefaults.standardUserDefaults().setValue(user?.uid, forKey: KEY_UID)
                            
                            let credential = FIREmailPasswordAuthProvider.credentialWithEmail(email, password: pwd)
                            FIRAuth.auth()?.signInWithCredential(credential) { (user, error) in
                            self.showErrorAlert("Account Created", msg: "Account did not exist, so an account with username \(email) was created")
                            self.performSegueWithIdentifier("loggedIn", sender: nil)
                            }
                        }
                    })
                }
            } else {
                self.performSegueWithIdentifier("loogedIn", sender: nil)
                }
            }
        } else {
            showErrorAlert("Email and password required", msg: "You must enter email and password")
        }
    }
    
    
    func showErrorAlert(title: String, msg: String) {
        let alert = UIAlertController(title: title, message: msg, preferredStyle: .Alert)
        let action = UIAlertAction(title: "OK", style: .Default, handler: nil)
        alert.addAction(action)
        presentViewController(alert, animated: true, completion: nil)
    }
}

