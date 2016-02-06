//
//  ProfileDataTableVC.swift
//  CarPooling
//
//  Created by Badr AlKhamissi on 2/3/16.
//  Copyright © 2016 Badr AlKhamissi. All rights reserved.
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

class ProfileDataVC: UITableViewController, MFMailComposeViewControllerDelegate {
    
    var userData = [String]()
    let cellIdentifier = "ProfileCell"
    let titleData = ["Name", "Email", "AUC ID", "Mobile"]
    let pageControllerIds = ["UserInfoId","PickUpId", "DropOffId"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    func getData(){
        if let user = PFUser.currentUser(){
            userData.append("\(user["FullName"]!)")
            userData.append("\(user.email!)")
            userData.append("\(user["AUCID"])")
            userData.append("\(user["Mobile"])")
        }else{
            userData.append("Badr AlKhamissi")
            userData.append("badr@khamissi.com")
            userData.append("900141572")
            userData.append("01006520798")
        }
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
    
    
    // MARK: Table View Delegate
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userData.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! DataCell
        cell.titleLbl.text = titleData[indexPath.row]
        cell.dataLbl.text = userData[indexPath.row]
        
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch(indexPath.row){
        case 1:
            let alertController = UIAlertController(title: "Email",
                message: "Do you want to send an email to \(userData[1])",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            alertController.addAction(UIAlertAction(title: "Yes",
                style: UIAlertActionStyle.Default,
                handler: { alertController in
                    self.sendEmail()
            }))
            alertController.addAction(UIAlertAction(title: "Cancel",
                style: UIAlertActionStyle.Default,
                handler: nil))
            // Display alert
            self.presentViewController(alertController, animated: true, completion: nil)
            break
        case 3:
            let alertController = UIAlertController(title: "Call",
                message: "Are you sure you want to call \(userData[3])",
                preferredStyle: UIAlertControllerStyle.Alert
            )
            alertController.addAction(UIAlertAction(title: "Yes",
                style: UIAlertActionStyle.Default,
                handler: { alertController in
                    self.callNumber(self.userData[3])
            }))
            alertController.addAction(UIAlertAction(title: "Cancel",
                style: UIAlertActionStyle.Default,
                handler: nil))
            // Display alert
            self.presentViewController(alertController, animated: true, completion: nil)
            break
        default:
            break
        }
    }
    
    // MARK: EMAIL
    
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