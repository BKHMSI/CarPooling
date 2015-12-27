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

class ProfileVC: UIViewController {
    
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
    
    @IBAction func unwindToProfileVC(segue: UIStoryboardSegue){
        // User Signed Up Successfully // Display his/her info
    }
}