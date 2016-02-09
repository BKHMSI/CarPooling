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


class OtherProfileVC: UIViewController {
    
    @IBOutlet weak var profileImgView: UIImageView!
    @IBOutlet weak var nameLbl: UILabel!
        private var containerTableVC: ProfileDataVC!
    var fullName = ""
    var userData = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        nameLbl.text = fullName
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? ProfileDataVC
            where segue.identifier == "OtherProfileEmbedSegue" {
                self.containerTableVC = vc
                vc.isCurrentUser = false
                for data in userData{
                    vc.userData.append(data)
                }
        }
    }
}