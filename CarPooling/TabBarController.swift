//
//  ProfileVC.swift
//  CarPooling
//
//  Created by Badr AlKhamissi on 12/27/15.
//  Copyright © 2015 Badr AlKhamissi. All rights reserved.
//

import Foundation
import UIKit



class TabBarController: UITabBarController {
    
    let buttonHighlight = UIImage(named: "add-outline.png") as UIImage?
    let buttonImage = UIImage(named: "add-black.png") as UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        createAddButton()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func createAddButton(){
        let button = UIButton()
        
        button.frame = CGRectMake(0.0, 0.0, buttonImage!.size.width, buttonImage!.size.height);
        button.setBackgroundImage(buttonImage, forState: UIControlState.Normal)
        button.setBackgroundImage(buttonHighlight, forState: UIControlState.Highlighted)
        button.addTarget(self, action: "goToSchedulePicker:", forControlEvents: UIControlEvents.TouchUpInside)
        let heightDifference:CGFloat = buttonImage!.size.height - self.tabBar.frame.size.height;
        if (heightDifference < 0){
            button.center = self.tabBar.center;
        }else{
            var center:CGPoint = self.tabBar.center;
            center.y = center.y - heightDifference/2.0;
            button.center = center;
        }
        self.view.addSubview(button)
    }
    
    func goToSchedulePicker(sender:UIButton){
        self.performSegueWithIdentifier("AddRideSegue", sender: self)
    }
    
    @IBAction func unwindToHome(segue: UIStoryboardSegue){
    
    }

}