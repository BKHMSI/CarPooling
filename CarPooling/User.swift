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
    static let sharedInstance = User(aucId: "",userName: "",password: "",mobile: "", name: "")
    var fullName:String
    var aucId:String 
    var userName:String
    var password:String?
    var mobile:String
    var photo:UIImage?
    var points:Int?
    var pickUpSchedule = [PickUpPin]()
    var dropOffSchedule = [PickUpPin]()
    var useFacebook:Bool?
    
    init(aucId:String, userName:String, password:String, mobile:String,name : String){
        fullName = name
        self.aucId = aucId
        self.userName = userName
        self.password = password
        self.mobile = mobile
    }
    
    init(aucId:String, userName:String, mobile:String, name: String){
        self.fullName = name
        self.aucId = aucId
        self.userName = userName
        self.mobile = mobile
    }
    
    func savePickUpSchedule() {
        for eachPin in pickUpSchedule {
            eachPin.savePinToParseAsPickUpPinAndConnectItToUserWithCurrentUser()
        }
    }
    
    func saveDropOffSchedule() {
        for eachPin in pickUpSchedule {
            eachPin.savePinToParseAsDropOffPinAndConnectItToUserWithCurrentUser()
        }
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
    
    func getFullName()->String{
        return fullName
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
    
    func setFullName(name:String){
        self.fullName = name
    }

}