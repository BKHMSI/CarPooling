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

extension String{
    func isValidPassword() -> Bool {
        if self.characters.count<8 {
            return false
        }
        self.rangeOfCharacterFromSet(NSCharacterSet.letterCharacterSet(), options: NSStringCompareOptions.LiteralSearch, range: nil) == nil
        if self.rangeOfCharacterFromSet(.letterCharacterSet(), options: .LiteralSearch, range: nil) == nil {
            return false
        }
        if self.rangeOfCharacterFromSet(.decimalDigitCharacterSet(), options: .LiteralSearch, range: nil) == nil {
            return false
        }
        else{
            return true
        }
    }
    func isValidAUCId() -> Bool {
        if self.characters.count != 9 {
            return false
        }else{
            return true
        }
    }
}


class SignUpVC: UIViewController {
    
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var aucIdTxtFld: UITextField!
    @IBOutlet weak var mobileTxtFld: UITextField!
    @IBOutlet weak var fullNameTxtFld: UITextField!
    
    var userSingelton = User.sharedInstance
    
    override func viewDidLoad() {
        passwordTxtFld.secureTextEntry = true
        super.viewDidLoad()
    }
    
    override func viewWillAppear(animated: Bool) {

    if UIDevice.currentDevice().valueForKey("orientation") as! Int != UIInterfaceOrientation.Portrait.rawValue {
            UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func signUpBtnPressed(sender: AnyObject) {
        // Build the terms and conditions alert
        
        if(isAUCian() && isValidEmail()){
            if passwordTxtFld.text!.isValidPassword() == true {
                if aucIdTxtFld.text?.isValidAUCId() == true {
                    let alertController = UIAlertController(title: "Agree to terms and conditions",
                        message: "Click I AGREE to signal that you agree to the End User Licence Agreement.",
                        preferredStyle: UIAlertControllerStyle.Alert
                    )
                    alertController.addAction(UIAlertAction(title: "I AGREE",
                        style: UIAlertActionStyle.Default,
                        handler: { alertController in
                            self.processSignUp()
                    })
                    )
                    alertController.addAction(UIAlertAction(title: "I do NOT agree",
                        style: UIAlertActionStyle.Default,
                        handler: nil)
                    )
                    // Display alert
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
                else{
                    let alertController = UIAlertController(title: "Invalid AUC ID",
                        message: nil,
                        preferredStyle: UIAlertControllerStyle.Alert
                    )
                    alertController.addAction(UIAlertAction(title: "OK",
                        style: UIAlertActionStyle.Default,
                        handler: nil)
                    )
                    //Display alert
                    self.presentViewController(alertController, animated: true, completion: nil)

                }
            }else {
                let alertController = UIAlertController(title: "Invalid Password",
                    message: "Password must be at least 8 characters and contain 1 letter and 1 number",
                    preferredStyle: UIAlertControllerStyle.Alert
                )
                alertController.addAction(UIAlertAction(title: "OK",
                    style: UIAlertActionStyle.Default,
                    handler: nil)
                )
                //Display alert
                self.presentViewController(alertController, animated: true, completion: nil)

            }
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
        
        // Create the user
        let user = PFUser()
        user.username = userEmailAddress
        user.password = userPassword
        user.email = userEmailAddress
        user["AUCID"] = aucIdTxtFld.text!
        user["Mobile"] = mobileTxtFld.text!
        user["FullName"] = fullNameTxtFld.text!
        
        user.signUpInBackgroundWithBlock {
            
            (succeeded: Bool, error: NSError?) -> Void in
            if error == nil {
                dispatch_async(dispatch_get_main_queue()) {
                    // Create User Object
                    self.createUser(user)
                    print("User Created Successfully, account awaiting confirmation\n")
                    self.performSegueWithIdentifier("goToSetDefaultLocationSegue", sender: self)
                }
            } else {
                if let _ = error!.userInfo["error"] {
                    let alertController = UIAlertController(title: "User Already Registered",
                        message: nil,
                        preferredStyle: UIAlertControllerStyle.Alert
                    )
                    alertController.addAction(UIAlertAction(title: "OK",
                        style: UIAlertActionStyle.Default,
                        handler: {
                            alertController in
                            self.performSegueWithIdentifier("goToSetDefaultLocationSegue", sender: self)
                        })
                    )
//                     Display alert
                    self.presentViewController(alertController, animated: true, completion: nil)

                }				
            }
        }
        
    }
    
    func createUser(user:PFUser){
        userSingelton.setId(aucIdTxtFld.text!)
        userSingelton.setPassword(passwordTxtFld.text!)
        userSingelton.setUserName(emailTxtFld.text!)
        userSingelton.setMobile(mobileTxtFld.text!)
        userSingelton.setFullName(fullNameTxtFld.text!)
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