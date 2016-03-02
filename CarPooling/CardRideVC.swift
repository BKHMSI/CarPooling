//
//  DayScheduleVC.swift
//  CarPooling
//
//  Created by Badr AlKhamissi on 2/3/16.
//  Copyright © 2016 Badr AlKhamissi. All rights reserved.
//

import Foundation
import UIKit
import Parse


class CardRideVC: UIViewController {
    
    
    @IBOutlet weak var cardBtn: UIButton!
    
    @IBOutlet weak var profileImg: UIImageView!
    @IBOutlet weak var timeLbl: UILabel!
    @IBOutlet weak var nameLbl: UILabel!
    
    var name = "", time = ""
    var thisUser:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        shadowCard()
        nameLbl.text = name
        timeLbl.text = time
        getUserData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func shadowCard(){
        cardBtn.layer.shadowColor = UIColor.blackColor().CGColor
        //cardBtn.layer.shadowOffset = CGSizeMake(5, 5)
        cardBtn.layer.shadowRadius = 5
        cardBtn.layer.shadowOpacity = 1.0
        cardBtn.sendSubviewToBack(self.view)
    }
    
    func getUserData(){
        dispatch_async(dispatch_get_main_queue()){
            
            let query = PFUser.query()
            query!.whereKey("FullName", equalTo: self.name)
            
            query!.findObjectsInBackgroundWithBlock {
                
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    print("Successfully retrieved \(objects!.count) scores.")
                    if let appUsers = objects{
                        for user in appUsers{
                            self.thisUser = User(aucId: user["AUCID"] as! String,userName: user["username"] as! String,mobile: user["Mobile"] as! String,name: user["FullName"] as! String)
                        }
                    } else {
                        // Log details of the failure
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                }
            }
        }
        
    }
    
    @IBAction func infoBtnPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("goToProfileFromCardSegue", sender: self)
    }

    @IBAction func sendRequestBtnPressed(sender: AnyObject) {
        // Find target user
        let userQuery = PFUser.query()
        userQuery!.whereKey("FullName", equalTo: name)
        
        // Find devices associated with these users
        let pushQuery = PFInstallation.query()
        pushQuery!.whereKey("user", matchesQuery: userQuery!)
        
        // Send push notification to query
        let push = PFPush()
        push.setQuery(pushQuery) // Set our Installation query
        push.setMessage("\(PFUser.currentUser()!["FullName"]) wants to ride with you")
        push.sendPushInBackground()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? OtherProfileVC
            where segue.identifier == "goToProfileFromCardSegue" {
                if thisUser != nil {
                    vc.fullName = thisUser!.fullName
                    vc.userData.append(thisUser!.fullName)
                    vc.userData.append(thisUser!.userName)
                    vc.userData.append(thisUser!.aucId)
                    vc.userData.append(thisUser!.mobile)
                }
  
        }
    }

}