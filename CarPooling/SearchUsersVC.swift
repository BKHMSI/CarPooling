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


class SearchUsersVC: UIViewController, UISearchBarDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    private var containerTableVC: SearchUsersTableVC!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
        searchBar.delegate = self
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? SearchUsersTableVC
            where segue.identifier == "SearchEmbedSegue" {
                self.containerTableVC = vc
        }
    }
    
    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        containerTableVC.shouldShowSearchResults = true;
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        containerTableVC.shouldShowSearchResults = false;
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        containerTableVC.shouldShowSearchResults = false;
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        containerTableVC.shouldShowSearchResults = false;
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        containerTableVC.filteredUsers = containerTableVC.users.filter({
            (text) -> Bool in
            let tmp: NSString = text.fullName
            let range = tmp.rangeOfString(searchText, options: NSStringCompareOptions.CaseInsensitiveSearch)
            return range.location != NSNotFound
        })
        if(containerTableVC.filteredUsers.count == 0){
            containerTableVC.shouldShowSearchResults = false;
        } else {
            containerTableVC.shouldShowSearchResults = true;
        }
        containerTableVC.tableView.reloadData()
    }
    
    @IBAction func unwindToSearchUsersSegue(unwindSegue: UIStoryboardSegue, towardsViewController subsequentVC: UIViewController) {
    }
    
}