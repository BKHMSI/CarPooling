//
//  ProfileVC.swift
//  CarPooling
//
//  Created by Badr AlKhamissi on 12/27/15.
//  Copyright © 2015 Badr AlKhamissi. All rights reserved.
//

import Foundation
import UIKit
import Parse

extension String {
    func isValudAUCEmail() -> Bool {
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
        passwordTxtFld.secureTextEntry = true
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
    }
    
    override func viewWillAppear(animated: Bool) {
        
        if UIDevice.currentDevice().valueForKey("orientation") as! Int != UIInterfaceOrientation.Portrait.rawValue {
            UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    @IBAction func signInBtnPressed(sender: AnyObject) {
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        var userEmailAddress = userNameTxtFld.text
        userEmailAddress = userEmailAddress!.lowercaseString
        
        let userPassword = passwordTxtFld.text
        
        PFUser.logInWithUsernameInBackground(userEmailAddress!, password:userPassword!) {
            (user: PFUser?, error: NSError?) -> Void in
            
            if user != nil{
                if user!["emailVerified"] as! Bool == true {
                    dispatch_async(dispatch_get_main_queue()) {
                        // User Signed In
                        print("User Signed In")
                        self.performSegueWithIdentifier("goToTabBarControllerForExploreAndProfile", sender: self)
                        self.activityIndicator.stopAnimating()
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
    
    func processSignOut() {
        // Sign out
        PFUser.logOut()
    }
    
    @IBAction func resetPassword(sender: AnyObject) {
        var textFieldOutside : UITextField?
        let alertController = UIAlertController(title: "A password reset request will be sent to the following email",
            message: nil,
            preferredStyle: UIAlertControllerStyle.Alert
        )
        alertController.addTextFieldWithConfigurationHandler({(textField: UITextField!) in
            textField.placeholder = "email"
            textFieldOutside = textField
        })
        alertController.addAction(UIAlertAction(title: "Send",
            style: UIAlertActionStyle.Default,
            handler: { alertController in
                if textFieldOutside?.text?.isValudAUCEmail() == true {
                    PFUser.requestPasswordResetForEmailInBackground(textFieldOutside!.text!)
                }else{
                    let invalidEmailAlertController = UIAlertController(title: "Invalid Email", message: "Email must be a valid AUC Email", preferredStyle: .Alert)
                    invalidEmailAlertController.addAction(UIAlertAction(title: "Ok",
                        style: UIAlertActionStyle.Default,
                        handler: nil)
                    )
                    self.presentViewController(invalidEmailAlertController, animated: true, completion: nil)
                }
        })
        )
        alertController.addAction(UIAlertAction(title: "cancel",
            style: UIAlertActionStyle.Default,
            handler: nil)
        )
        // Display alert
        self.presentViewController(alertController, animated: true, completion: nil)

    }
    
    @IBAction func unwindToSignInVC(segue: UIStoryboardSegue){
        if segue.identifier == "finishRegistrationSegue" {
            User.sharedInstance.saveDropOffSchedule()
            User.sharedInstance.savePickUpSchedule()
            print("I'm In UnwindToSignInVC!")
        }else if segue.identifier == "cancelSegue" {
        //Do Nothing
        }
    }
}