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



class SearchUsersTableVC: UITableViewController, UISearchBarDelegate{
    
    
    var users = [String]()
    var filteredUsers = [String]()
    var shouldShowSearchResults:Bool = false
    
    let cellIdentifier = "userCellId"
    
    var sampleData = ["Badr", "Bahaa", "Mai", "Candy"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUsers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
   
    func initUsers(){
        
        for name in sampleData {
            users.append(name)
        }
        
        dispatch_async(dispatch_get_main_queue()){
            let query:PFQuery = PFQuery(className: "User")
         
            query.whereKey("username", notEqualTo: (PFUser.currentUser()?.username)!)
            query.includeKey("FullName")
            
            query.findObjectsInBackgroundWithBlock {
                
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    print("Successfully retrieved \(objects!.count) scores.")
                    if let allObjects = objects {
                        for user in allObjects {
                            self.users.append(user["FullName"] as! (String))
                        }
                    }
                } else {
                    print("Error: \(error!) \(error!.userInfo)")
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
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath)
        cell.textLabel?.text = shouldShowSearchResults ? filteredUsers[indexPath.row]:users[indexPath.row]
        return cell
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
}