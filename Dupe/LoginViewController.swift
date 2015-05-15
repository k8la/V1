//
//  LoginViewController.swift
//  Duplicity
//
//  Created by Kaitlyn on 3/13/15.
//  Copyright (c) 2015 K8La. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, FBLoginViewDelegate {
  
    var signupActive = true
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()

    
    //////////////////////////// Alert /////////////////////////////////
    
    
    func displayAlert(title:String, error:String) {
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: .Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
        
    }
    
/////////////////////////////// FACEBOOK LOGIN ////////////////////
//    var fbl: FBLoginView = FBLoginView()
//    
//    
//    func loginViewShowingLoggedInUser(loginView: FBLoginView) {
//        logStatusTxt.text = "You are logged in!"
//    }
//    
//    func loginViewFetchedUserInfo(loginView: FBLoginView?, user: FBGraphUser) {
////        profilePictureView.profileID = user.objectID
//        userNameTxt.text = user.first_name + " " + user.last_name
//    }
//    
//    func loginViewShowingLoggedOutUser(loginView: FBLoginView?) {
////        profilePictureView.profileID = nil
//        userNameTxt.text = ""
//        logStatusTxt.text = "You are logged out!"
//    }
//   
//    @IBAction func submit(sender: UIButton) {
//        
//        
//    }
//////////////////////////////////////////////////////////////////
    
  
    
    
    
    @IBOutlet weak var email: UITextField!
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    
    @IBOutlet var signUpButton: UIButton!
    
    @IBOutlet var signUpToggleButton: UIButton!
    
    
    
    @IBAction func toggleSignUp(sender: AnyObject) {
        
        if signupActive == true {
            
            signupActive = false
            
            signUpButton.setTitle("Log In", forState: UIControlState.Normal)
            
            
            signUpToggleButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            
        } else {
            
            signupActive = true
            
            
            signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            
            signUpToggleButton.setTitle("Log In", forState: UIControlState.Normal)
            
            
        }
        
        
    }
    
    @IBAction func signUp(sender: AnyObject) {
        
        var error = ""
        
        if username.text == "" || password.text == "" {
            
            error = "Please enter a username and password"
            
        }
        
        
        if error != "" {
            
            displayAlert("Error", error: error)
            
        } else {
            
            

            
            if signupActive == true {
                
                var user = PFUser()
                user.username = username.text
                user.password = password.text
//                user.email = email.text
                
                
                activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                UIApplication.sharedApplication().beginIgnoringInteractionEvents()
                
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool!, signupError: NSError!) -> Void in
                    
                    self.activityIndicator.stopAnimating()
                    UIApplication.sharedApplication().endIgnoringInteractionEvents()
                    
                    if signupError == nil  {
                        // Hooray! Let them use the app now.
                        
                        println("signed up")
                        
                        self.performSegueWithIdentifier("ListViewController", sender: "self")
                        
                        
                    } else {
                        

                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        
                        if let errorString = signupError.userInfo?["error"] as? NSString {
                            
                            // Update - added as! String
                            
                            error = errorString as String
                            println(signupError)
                            
                        } else {
                            
                            error = "Please try again later."
                            
                        }
                        
                        self.displayAlert("Could Not Sign Up", error: error)
                        
                    }
                }
                
            } else {
                
                
                activityIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 50, 50))
                activityIndicator.center = self.view.center
                activityIndicator.hidesWhenStopped = true
                activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.WhiteLarge
                view.addSubview(activityIndicator)
                activityIndicator.startAnimating()
                UIApplication.sharedApplication().beginIgnoringInteractionEvents()
                
                PFUser.logInWithUsernameInBackground(username.text, password:password.text) {
                    (user: PFUser!, signupError: NSError!) -> Void in
                    

                    
                    

                    
                    if signupError == nil {
                        println("logged in")
                        self.performSegueWithIdentifier("ListViewController", sender: "self")
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                    } else {
                        
                        self.activityIndicator.stopAnimating()
                        UIApplication.sharedApplication().endIgnoringInteractionEvents()
                        
                        if let errorString = signupError.userInfo?["error"] as? NSString {
                            
                            // Update - added as! String
                            
                            error = errorString as String
                            
                        } else {
                            
                            
                            error = "Please try again later."
                            
                        }
                        
                        self.displayAlert("Could Not Log In", error: error)
                        
                        
                    }
                }
                
                
            }
            
            
        }
        
        
    }
    
    

   
    func didTapView(){
        self.view.endEditing(true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
//        fbl.delegate = self
//        loginView.readPermissions = ["public_profile", "email", "user_friends"]
        
        /////////////////// Dismiss Keyboard /////////////////////////////////
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: "didTapView")
        self.view.addGestureRecognizer(tapRecognizer)
        
        //////////////////////////////////////////////////////////////////////
 
    }
    
    override func viewDidAppear(animated: Bool) {
        if PFUser.currentUser() != nil {
            
            self.performSegueWithIdentifier("ListViewController", sender: self)
            
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
