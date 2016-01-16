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
import MessageUI

class DataCell:UITableViewCell{
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var dataLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}

class ProfileVC: UIViewController,UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var profilePicImgView: UIImageView!
    
    var userData = [String]()
    let titleData = ["Name", "Email", "AUC ID", "Mobile"]
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func getData(){
        let user = PFUser.currentUser()
        userData.append("\(user!.username!)")
        userData.append("\(user!.email!)")
        userData.append("\(user!["AUCID"])")
        userData.append("\(user!["Mobile"])")
        displayProfilePic()
        
        dispatch_async(dispatch_get_main_queue()) {
            self.tableView.reloadData()
        }
    }
    
    func displayProfilePic(){
        let graphRequest : FBSDKGraphRequest = FBSDKGraphRequest(graphPath: "me", parameters:["fields": "email, name, education"])
        graphRequest.startWithCompletionHandler({ (connection, result, error) -> Void in
            if ((error) != nil){
                // Process error
                print("Error: \(error)")
            }else{
                // Get Profile Picture
                let id: NSString = result.valueForKey("id") as! NSString
                let url = NSURL(string: "https://graph.facebook.com/\(id)/picture?type=large")
                let urlRequest = NSURLRequest(URL: url!)
                
                NSURLConnection.sendAsynchronousRequest(urlRequest, queue: NSOperationQueue.mainQueue()) { (response:NSURLResponse?, data:NSData?, error:NSError?) -> Void in
                    
                    // Display the image
                    var image = UIImage(data: data!)
                    image = image?.rounded
                    image = image?.circle
                    self.profilePicImgView.image = image
                }
            }
        })

    }
    
    func sendEmail(){
        // Doesn't Work on Simulator
        let picker = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.presentViewController(picker, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func callNumber(phoneNumber:String) {
        if let phoneCallURL:NSURL = NSURL(string: "tel://\(phoneNumber)") {
            let application:UIApplication = UIApplication.sharedApplication()
            if (application.canOpenURL(phoneCallURL)) {
                application.openURL(phoneCallURL);
            }
        }
    }
    
    
    // Mark: Table View Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cellIdentifier = "cellId"
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DataCell
        cell.titleLbl.text = titleData[indexPath.row]
        cell.dataLbl.text = userData[indexPath.row]

        return cell
    }
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch(indexPath.row){
        case 1:
            sendEmail()
            break
        case 3:
            callNumber(userData[3])
            break
        default:
            break
        }
    }
    
    // Mark: EMAIL
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {
        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self // Extremely important to set the --mailComposeDelegate-- property, NOT the --delegate-- property
        
        mailComposerVC.setToRecipients([userData[3]])
        mailComposerVC.setSubject("I need a ride - Carpooling App")
        mailComposerVC.setMessageBody("", isHTML: false)

        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let alertController = UIAlertController(
            title: "Could Not Send Email",
            message: "our device could not send e-mail.  Please check e-mail configuration and try again",
            preferredStyle: UIAlertControllerStyle.Alert
        )
        alertController.addAction(UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler: nil)
        )
        // Display alert
        self.presentViewController(
            alertController,
            animated: true,
            completion: nil
        )
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
}