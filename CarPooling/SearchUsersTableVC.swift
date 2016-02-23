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

class UsersDataCell:UITableViewCell{
    
    @IBOutlet weak var nameLbl: UILabel!
    @IBOutlet weak var isActiveLbl: UILabel!
    @IBOutlet weak var profilePicImgView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}

class SearchUsersTableVC: UITableViewController, UISearchBarDelegate{
    
    
    var users = [User]()
    var filteredUsers = [User]()
    var shouldShowSearchResults:Bool = false
    let cellIdentifier = "userCellId"
    var selectedIndex = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        // Check for internet connection first
        initUsers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initUsers(){
        let query = PFUser.query()
        query!.whereKey("username", notEqualTo: (PFUser.currentUser()?.username)!)
        
        dispatch_async(dispatch_get_main_queue()){
            
            let query = PFUser.query()
            query!.whereKey("username", notEqualTo: (PFUser.currentUser()?.username)!)
            
            query!.findObjectsInBackgroundWithBlock {
                
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    print("Successfully retrieved \(objects!.count) scores.")
                    if let appUsers = objects{
                        for user in appUsers{
                            self.users.append(User(aucId: user["AUCID"] as! String,userName: user["username"] as! String,mobile: user["Mobile"] as! String,name: user["FullName"] as! String))
                            self.tableView.reloadData()
                        }
                    } else {
                        // Log details of the failure
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                }
            }
        }
        self.tableView.reloadData()
    }
    
    // MARK: Table View Delegate
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return shouldShowSearchResults ? filteredUsers.count:users.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! UsersDataCell
        cell.nameLbl.text = shouldShowSearchResults ? filteredUsers[indexPath.row].fullName:users[indexPath.row].fullName
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedIndex = indexPath.row
        self.performSegueWithIdentifier("GoToUserSegue", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? OtherProfileVC
            where segue.identifier == "GoToUserSegue" {
                vc.fullName = users[selectedIndex].fullName
                vc.userData.append(users[selectedIndex].fullName)
                vc.userData.append(users[selectedIndex].userName)
                vc.userData.append(users[selectedIndex].aucId)
                vc.userData.append(users[selectedIndex].mobile)
        }
    }
    
}