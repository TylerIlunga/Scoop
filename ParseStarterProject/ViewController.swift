//
//  ViewController.swift
//
//  Copyright 2011-present Parse Inc. All rights reserved.
//

import UIKit
import Parse

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var riderLabel: UILabel!
    @IBOutlet weak var driverLabel: UILabel!
    @IBOutlet weak var `switch`: UISwitch!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var signInButton: UIButton!
    
    
    
    var signUpState = true
    
    
    @IBAction func signUp(sender: AnyObject) {
        if username.text == "" || password.text == "" {
            displayAlert("Missing Field(s)", message: "Username AND Password required")
            
        } else {
            
            var user = PFUser()
            user.username = username.text
            user.password = password.text
            
            if signUpState == true {
            
                user["isDriver"] = `switch`.on
            
                    user.signUpInBackgroundWithBlock {
                        (succeeded, error: NSError?) -> Void in
                        if let error = error {
                            let errorString = error.userInfo["error"] as! NSString
                    
                            self.displayAlert("Sign Up Failed", message: errorString as String)
                    
                        } else {
                            if self.`switch`.on == true {
                                
                                self.performSegueWithIdentifier("loginDriver", sender: self)
                            
                            } else {
                     
                                self.performSegueWithIdentifier("loginRider", sender: self)
                                
                            }
                }
                        
                        
        }
                } else {
                
                PFUser.logInWithUsernameInBackground(username.text!, password:password.text!) {
                    (user: PFUser?, error: NSError?) -> Void in
                    if let user = user {
                        
                        if user["isDriver"]! as! Bool == true {
                            
                            self.performSegueWithIdentifier("loginDriver", sender: self)
                            
                        } else {
                            
                            self.performSegueWithIdentifier("loginRider", sender: self)
                            
                        }
                        
                    } else {
                        let errorString = error!.userInfo["error"] as! NSString
                        
                        self.displayAlert("Login Failed", message: errorString as String)
                    }
                }

            
                }
        }
        
    }
    
    @IBAction func signIn(sender: AnyObject) {
        if signUpState == true {
            
            signUpButton.setTitle("Log In", forState: UIControlState.Normal)
            
            signInButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            signUpState = false
            
            riderLabel.alpha = 0
            driverLabel.alpha = 0
            `switch`.alpha = 0
        
        } else {
        
            signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            signInButton.setTitle("Log In", forState: UIControlState.Normal)
            
            signUpState = true
            
            riderLabel.alpha = 1
            driverLabel.alpha = 1
            `switch`.alpha = 1
        
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "DismissKeyboard")
        view.addGestureRecognizer(tap)
        
        self.username.delegate = self;
        self.password.delegate = self;
        
        self.navigationController?.navigationBarHidden = true
        
        

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func displayAlert(title: String, message: String) {
        var alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func DismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser()?.username != nil {
        
            if PFUser.currentUser()?["isDriver"]! as! Bool == true {
                
                self.performSegueWithIdentifier("loginDriver", sender: self)
                
            } else {
                
                self.performSegueWithIdentifier("loginRider", sender: self)
                
            }

        }
    }
}

