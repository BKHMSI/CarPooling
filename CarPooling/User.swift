//
//  User .swift
//  CarPooling
//
//  Created by Badr AlKhamissi on 12/26/15.
//  Copyright © 2015 Badr AlKhamissi. All rights reserved.
//

import Foundation
import UIKit
import Parse

extension PFUser{
    
}

class User {
    static let sharedInstance = User(aucId: "",userName: "",password: "",mobile: "")
    var aucId:String 
    var userName:String
    var password:String?
    var mobile:String
    var photo:UIImage?
    var points:Int?
    var pickUpSchedule = [PickUpPin]()
    
    init(aucId:String, userName:String, password:String, mobile:String){
        self.aucId = aucId
        self.userName = userName
        self.password = password
        self.mobile = mobile
    }
    
    // MARK: Getters
    
    func getId()->String{
        return aucId
    }
    
    func getUserName()->String{
        return userName;
    }
    
    func getPassword()->String{
        return password!;
    }
    
    func getMobile()->String{
        return mobile;
    }
    
    func getPoints()->Int{
        return points != nil ? points!:0
    }
    
    
    // MARK: Setters
    
    func setId(aucId:String){
        self.aucId = aucId
    }
    
    func setUserName(userName:String){
        self.userName = userName
    }
    
    func setPassword(password:String){
        self.password = password
    }
    
    func setMobile(mobile:String){
        self.mobile = mobile
    }
    
    func setPhoto(photo:UIImage){
        self.photo = photo
    }

}