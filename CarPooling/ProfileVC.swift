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


class ProfileVC: UIViewController {
    
    @IBOutlet weak var profilePicImgView: UIImageView!
    private var containerTableVC: ProfileDataVC!
    var isCurrentUser:Bool = true;

    override func viewDidLoad() {
        super.viewDidLoad()
        displayProfilePic()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let vc = segue.destinationViewController as? ProfileDataVC
            where segue.identifier == "ProfileEmbedSegue" {
                self.containerTableVC = vc
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
}