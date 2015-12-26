//
//  Driver .swift
//  CarPooling
//
//  Created by Badr AlKhamissi on 12/26/15.
//  Copyright © 2015 Badr AlKhamissi. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

class Driver:User {
    
    private var estimatedPickUpTime:NSDate? // EPT
    private var pickUpLocation:CLLocation? // PUL
    private var pickUpRequestsArray : [Request]
    private var pickUpRequestsNumber : Int = 0 {
        willSet(newValue){
            
        }
    }
    
    init(aucId:String, userName:String, password:String, mobile:NSNumber, ept:NSDate, pul:CLLocation){
        estimatedPickUpTime = ept // Estimated PickUp Time
        pickUpLocation = pul // Pick Up Location
        pickUpRequestsArray = [Request]()
        super.init(aucId: aucId, userName: userName, password: password, mobile: mobile)
    }
    
    override init(aucId: String, userName: String, password: String, mobile: NSNumber) {
        pickUpRequestsArray = [Request]()
        super.init(aucId: aucId, userName: userName, password: password, mobile: mobile)
    }
    
    func setEstimatedPickUpTime(ept: NSDate){
        estimatedPickUpTime = ept
    }
    
    func setPickUpLocation(pul: CLLocation){
        pickUpLocation = pul
    }
    
    func getEstimatedPickUpTime()->NSDate?{
        return estimatedPickUpTime
    }
    
    func getPickUpLocation()->CLLocation?{
        return pickUpLocation
    }
    
    func updateRideRequests(){
        
    }
    func processRideRequestAtIndex(){
        
    }
    
}