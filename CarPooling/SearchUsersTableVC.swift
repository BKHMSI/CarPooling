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
    
    
    var users = [String]()
    var userss = [User]()
    var filteredUsers = [String]()
    var shouldShowSearchResults:Bool = false
    
    let cellIdentifier = "userCellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
                            if((user["FullName"]) != nil){
                                self.users.append(user["FullName"] as! String)
                            }else{
                                self.users.append(user["username"] as! String)
                            }
                            self.userss.append(User(aucId: user["AUCID"] as! String,userName: user["username"] as! String,mobile: user["Mobile"] as! String,name: user["FullName"] as! String))
                        }
                    } else {
                        // Log details of the failure
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                }
            }
        }
        
        // Releod Data
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
        cell.nameLbl.text = shouldShowSearchResults ? filteredUsers[indexPath.row]:userss[indexPath.row].fullName
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}