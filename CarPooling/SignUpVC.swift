//
//  SignUpVC.swift
//  CarPooling
//
//  Created by Badr AlKhamissi on 12/27/15.
//  Copyright © 2015 Badr AlKhamissi. All rights reserved.
//

import Foundation
import UIKit
import Parse
import CoreData

class SignUpVC: UIViewController {
    
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var aucIdTxtFld: UITextField!
    @IBOutlet weak var mobileTxtFld: UITextField!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var userSingelton = User.sharedInstance
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signUpBtnPressed(sender: AnyObject) {
        // Build the terms and conditions alert
        
        if(isAUCian() && isValidEmail()){
            let alertController = UIAlertController(title: "Agree to terms and conditions",
                message: "Click I AGREE to signal that you agree to the End User Licence Agreement.",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            alertController.addAction(UIAlertAction(title: "I AGREE",
                style: UIAlertActionStyle.Default,
                handler: { alertController in self.processSignUp()})
            )
            alertController.addAction(UIAlertAction(title: "I do NOT agree",
                style: UIAlertActionStyle.Default,
                handler: nil)
            )
            
            // Display alert
            self.presentViewController(alertController, animated: true, completion: nil)
        }else{
            let alertController = UIAlertController(title: "You must be an AUCian",
                message: "Make sure that you entered your correct AUC email address",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            
            alertController.addAction(UIAlertAction(title: "OK",
                style: UIAlertActionStyle.Default,
                handler: nil)
            )
            
            
            // Display alert
            self.presentViewController(alertController, animated: true, completion: nil)
        }
        
       
    }
    
    func processSignUp() {
        
        var userEmailAddress = emailTxtFld.text
        let userPassword = passwordTxtFld.text
        
        // Ensure username is lowercase
        userEmailAddress = userEmailAddress!.lowercaseString
        
        // Start activity indicator
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        
        // Create the user
        let user = PFUser()
        user.username = userEmailAddress
        user.password = userPassword
        user.email = userEmailAddress
        
        user.signUpInBackgroundWithBlock {
            (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()) {
                    // Create User Object
                    self.createUser()
                    self.performSegueWithIdentifier("unwindToProfileVC", sender: self)
                }
            } else {
                self.activityIndicator.stopAnimating()
                if let message: AnyObject = error!.userInfo["error"] {
                    //self.message.text = "\(message)"
                    print("Error: \(message)")
                }				
            }
        }
    }
    
    func createUser(){
        userSingelton.setId(aucIdTxtFld.text!)
        userSingelton.setPassword(passwordTxtFld.text!)
        userSingelton.setUserName(emailTxtFld.text!)
        userSingelton.setMobile(mobileTxtFld.text!)
    }
    
    // MARK: Validation Functions
    
    func isAUCian()->Bool{
        if emailTxtFld.text?.containsString("aucegypt.edu") != nil{
            return true
        }else{
            return false
        }
    }
    
    func isValidEmail() -> Bool {
        let emailStr = emailTxtFld.text
        let emailRegEx = "^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$"
        
        let email = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return email.evaluateWithObject(emailStr)
    }
  
}