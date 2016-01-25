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
import FBSDKLoginKit



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
    func isAUCID() -> Bool {
        if self.characters.count != 9 {
            return false
        }else{
            return true
        }
    }
}


extension UIImage {
    var rounded: UIImage? {
        let imageView = UIImageView(image: self)
        imageView.layer.cornerRadius = min(size.height/2, size.width/2)
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.renderInContext(context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
    var circle: UIImage? {
        let square = CGSize(width: min(size.width, size.height), height: min(size.width, size.height))
        let imageView = UIImageView(frame: CGRect(origin: CGPoint(x: 0, y: 0), size: square))
        imageView.contentMode = .ScaleAspectFill
        imageView.image = self
        imageView.layer.cornerRadius = square.width/2
        imageView.layer.masksToBounds = true
        UIGraphicsBeginImageContext(imageView.bounds.size)
        guard let context = UIGraphicsGetCurrentContext() else { return nil }
        imageView.layer.renderInContext(context)
        let result = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return result
    }
}

class SignUpVC: UIViewController, FBSDKLoginButtonDelegate {

    
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwordTxtFld: UITextField!
    @IBOutlet weak var aucIdTxtFld: UITextField!
    @IBOutlet weak var mobileTxtFld: UITextField!
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var fbBtn: FBSDKLoginButton!
    @IBOutlet weak var fullNameTxtFld: UITextField!
    
    var userSingelton = User.sharedInstance
    
    override func viewDidLoad() {
        passwordTxtFld.secureTextEntry = true
        super.viewDidLoad()
        if (FBSDKAccessToken.currentAccessToken() != nil){
            // User is already logged in, do work such as go to next view controller.
            displayUserData()
        }else{
            fbBtn = FBSDKLoginButton()
            //fbBtn.delegate = self
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
    }
    
    override func viewWillAppear(animated: Bool) {

    if UIDevice.currentDevice().valueForKey("orientation") as! Int != UIInterfaceOrientation.Portrait.rawValue {
            UIDevice.currentDevice().setValue(UIInterfaceOrientation.Portrait.rawValue, forKey: "orientation")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func shouldAutorotate() -> Bool {
        return false
    }
    
    override func supportedInterfaceOrientations() -> UIInterfaceOrientationMask {
        return UIInterfaceOrientationMask.Portrait
    }
    
    @IBAction func signUpBtnPressed(sender: AnyObject) {
        // Build the terms and conditions alert
        
        if(isAUCian() && isValidEmail()){
            if passwordTxtFld.text!.isValidPassword() == true {
                if aucIdTxtFld.text?.isAUCID() == true {
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

                if let message: AnyObject = error!.userInfo["error"] {
                    //self.message.text = "\(message)"
                    print("Error: \(message)")
                }

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
    
    func circleImageView(){
        
        // Circle
        self.profileImgView.layer.cornerRadius = self.profileImgView.frame.size.width / 2;
        self.profileImgView.clipsToBounds = true;
        
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
    

    
    // Mark: Facebook
    
    func displayUserData(){
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters:["fields": "email, name, education"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in

            if ((error) != nil){
                // Process error
                print("Error: \(error)")
            }else{
                print("Results: \n \(result)")

                if let userName : NSString = result.valueForKey("name") as? NSString{
                    self.fullNameTxtFld.text = userName as String
                }

                // Get Profile Picture
                let id: NSString = result.valueForKey("id") as! NSString
                let url = NSURL(string: "https://graph.facebook.com/\(id)/picture?type=large")
                let urlRequest = NSURLRequest(URL: url!)
                
                NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse?, data:NSData?, error:NSError?) -> Void in
                    
                    // Display the image
                    var image = UIImage(data: data!)
                    image = image?.rounded
                    image = image?.circle
                    self.profileImgView.image = image
                }
            }
        })
    }
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        print("User Logged In")
        if ((error) != nil){
            // Process error
            print("\(error)")
            
        }else if result.isCancelled {
            // Handle cancellations
        }
        else {
            displayUserData()
            // If you ask for multiple permissions at once, you
            // should check if specific permissions missing
            if result.grantedPermissions.contains("email"){
                // Do work
            }
        }
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
    }
    

}