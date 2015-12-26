//
//  User .swift
//  CarPooling
//
//  Created by Badr AlKhamissi on 12/26/15.
//  Copyright © 2015 Badr AlKhamissi. All rights reserved.
//

import Foundation
import UIKit

class User {
    //MARK: Properties
    
    var aucId:String
    var userName:String
    var password:String
    var mobile:NSNumber
    var photo:UIImage?
    var points:Int?
    
    //MARK: Initialiser
    
    init(aucId:String, userName:String, password:String, mobile:NSNumber){
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
        return password;
    }
    
    func getMobile()->NSNumber{
        return mobile;
    }
    
    func getPoints()->Int{
        if (points != nil){
            return points!
        }else {
            return 0;
        }
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
    
    func setPhoto(photo:UIImage){
        self.photo = photo
    }

}