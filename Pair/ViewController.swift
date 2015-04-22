//
//  ViewController.swift
//  Pair
//
//  Created by Chris Fowles on 3/29/15.
//  Copyright (c) 2015 Chris Fowles. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var signupActive = true
    
    func displayAlert(title: String, error: String){
        
        var alert = UIAlertController(title: title, message: error, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: { action in
            
            self.dismissViewControllerAnimated(true, completion: nil)
            
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    @IBOutlet var username: UITextField!
    
    @IBOutlet var password: UITextField!
    
    @IBOutlet weak var subtext: UILabel!
    
    @IBOutlet var signUpLabel: UILabel!
    
    
    @IBOutlet var signUpButton: UIButton!
    
    
    @IBAction func toggleSignUp(sender: AnyObject) {
        
        if signupActive == true {
            
            signupActive = false
            
            signUpLabel.text = "Use the form to login."
            
            signUpButton.setTitle("Log In", forState: UIControlState.Normal)
            
            signUpToggleButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            subtext.text = "New?"
            
        } else {
            
            signupActive = true
            
            signUpLabel.text = "Use the form to sign up"
            
            signUpButton.setTitle("Sign Up", forState: UIControlState.Normal)
            
            signUpToggleButton.setTitle("Log In", forState: UIControlState.Normal)
            
            subtext.text = "Already Registered?"
            
        }
        
    }
    
    
    @IBOutlet var signUpToggleButton: UIButton!
    
    
    
    @IBAction func signup(sender: AnyObject) {
        
        var error = ""
        
        if username.text == "" || password.text == ""{
            error = "Please enter a username & password"
        }
        
        if error != "" {
            
            displayAlert("error in form yo", error: error)
            
        } else {
            
            if signupActive == true {
                
                var user = PFUser();
                user.username = username.text
                user.password = password.text
                
                user.signUpInBackgroundWithBlock {
                    (succeeded: Bool!, signupError: NSError!) -> Void in
                    if signupError == nil {
                        println("signup")
                    } else {
                        if let errorString = signupError.userInfo?["error"] as? NSString {
                            error = errorString
                        } else {
                            error = "Try again later!"
                        }
                        
                        self.displayAlert("Signup Failed ) :", error: error)
                        
                    }
                }
            } else {
                
                PFUser.logInWithUsernameInBackground(username.text, password:password.text) {
                    (user: PFUser!, signupError: NSError!) -> Void in
                    if signupError == nil {
                        self.performSegueWithIdentifier("jumpToAddPair", sender: self)
                        println("logged in")
                    } else {
                        if let errorString = signupError.userInfo?["error"] as? NSString {
                            error = errorString
                        } else {
                            error = "Try again later!"
                        }
                        
                        self.displayAlert("Signup Failed ) :", error: error)
                        
                    }
                }
                
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        println(PFUser.currentUser())
        
    }
    
    override func viewDidAppear(animated: Bool) {
        
        if PFUser.currentUser() != nil {
        
            self.performSegueWithIdentifier("jumpToAddPair", sender: self)
        
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

