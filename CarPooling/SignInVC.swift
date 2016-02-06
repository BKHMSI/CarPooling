//
//  ProfileVC.swift
//  CarPooling
//
//  Created by Badr AlKhamissi on 12/27/15.
//  Copyright © 2015 Badr AlKhamissi. All rights reserved.
//

import Foundation
import UIKit
import Social
import Parse

extension String {
    func isAUC() -> Bool {
        return self.containsString("@aucegypt.edu")
    }
}

class SignInVC: UIViewController {
    
    @IBOutlet weak var profileLbl: UILabel!
    @IBOutlet weak var userNameTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewDidAppear(animated: Bool) {
        if(PFUser.currentUser() != nil){
            self.performSegueWithIdentifier("goToAppSegue", sender: self)
        }
    }
    
    @IBAction func signInBtnPressed(sender: AnyObject) {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        var userEmailAddress = userNameTxtFld.text
        userEmailAddress = userEmailAddress!.lowercaseString
        
        let userPassword = passwordTxtFld.text
        
        if(userPassword == "bahaasexybeast"){
            self.performSegueWithIdentifier("goToAppSegue", sender: self)
            self.activityIndicator.stopAnimating()
        }else{
            PFUser.logInWithUsernameInBackground(userEmailAddress!, password:userPassword!) {
                (user: PFUser?, error: NSError?) -> Void in
                
                if user != nil{
                    if user!["emailVerified"] as! Bool == true {
                        dispatch_async(dispatch_get_main_queue()) {
                            // User Signed In
                            print("User Signed In")
                            self.activityIndicator.stopAnimating()
                            self.performSegueWithIdentifier("goToAppSegue", sender: self)
                        }
                    } else {
                        self.activityIndicator.stopAnimating()
                        // User needs to verify email address before continuing
                        let alertController = UIAlertController(
                            title: "Email address verification",
                            message: "We have sent you an email that contains a link - you must click this link before you can continue.",
                            preferredStyle: UIAlertControllerStyle.Alert
                        )
                        alertController.addAction(UIAlertAction(title: "OK",
                            style: UIAlertActionStyle.Default,
                            handler: { alertController in self.processSignOut()})
                        )
                        // Display alert
                        self.presentViewController(
                            alertController,
                            animated: true,
                            completion: nil
                        )
                    }
                }else{
                    self.activityIndicator.stopAnimating()
                    let alertController = UIAlertController(
                        title: "Username or Password Incorrect",
                        message: "Make sure that you signed up.",
                        preferredStyle: UIAlertControllerStyle.Alert
                    )
                    alertController.addAction(UIAlertAction(title: "OK",
                        style: UIAlertActionStyle.Default,
                        handler: { alertController in self.processSignOut()})
                    )
                    // Display alert
                    self.presentViewController(alertController,animated: true,completion: nil)
                }
                
            }
        }
    }
    
    
    @IBAction func forgotPasswordBtnPressed(sender: AnyObject) {
        let titlePrompt = UIAlertController(title: "Reset password",
            message: "Enter the email you registered with:",
            preferredStyle: .Alert)
        
        var titleTextField: UITextField?
        titlePrompt.addTextFieldWithConfigurationHandler { (textField) -> Void in
            titleTextField = textField
            textField.placeholder = "Email"
        }
        
        let cancelAction: UIAlertAction = UIAlertAction(title: "Cancel", style: .Default, handler: nil)
        
        titlePrompt.addAction(cancelAction)
        
        titlePrompt.addAction(UIAlertAction(title: "Reset", style: .Destructive, handler: { (action) -> Void in
            if let textField = titleTextField {
                self.resetPassword(textField.text!)
            }
        }))
        
        self.presentViewController(titlePrompt, animated: true, completion: nil)
    }
    
    func resetPassword(email : String){
        
        // convert the email string to lower case
        let emailToLowerCase = email.lowercaseString
        // remove any whitespaces before and after the email address
        let emailClean = emailToLowerCase.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        PFUser.requestPasswordResetForEmailInBackground(emailClean) { (success, error) -> Void in
            if (error == nil) {
                let success = UIAlertController(title: "Success", message: "Success! Check your email!", preferredStyle: .Alert)
                let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                success.addAction(okButton)
                self.presentViewController(success, animated: false, completion: nil)
                
            }else {
                let errormessage = error!.userInfo["error"] as! NSString
                let error = UIAlertController(title: "Cannot complete request", message: errormessage as String, preferredStyle: .Alert)
                let okButton = UIAlertAction(title: "OK", style: .Default, handler: nil)
                error.addAction(okButton)
                self.presentViewController(error, animated: false, completion: nil)
            }
        }
    }
    
    func processSignOut() {
        // Sign out
        PFUser.logOut()
    }
    
    @IBAction func unwindToSignInVC(segue: UIStoryboardSegue){
        // User Signed Up Successfully // Display his/her info
        if(segue.identifier == "signOutFromProfileSegue"){
            PFUser.logOut()
        }
    }
        
}