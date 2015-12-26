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
    
    //Estimated Time at which driver will leave with car from specified location
    private var estimatedPickUpTime:NSDate? // EPT
    //Location at which driver will start trip to University From
    private var pickUpLocation:CLLocation? // PUL
    //Array of requests made to driver for pickup
    private var pickUpRequestsArray : [Request]
    
    //Number of requests, is updated in background with property observer for increased functionality
    private var pickUpRequestsNumber : Int = 0 {
        willSet(newValue){
            
        }
    }
    
    //initializer with predefined paramaters EPL PUL
    init(aucId:String, userName:String, password:String, mobile:NSNumber, ept:NSDate, pul:CLLocation){
        estimatedPickUpTime = ept // Estimated PickUp Time
        pickUpLocation = pul // Pick Up Location
        pickUpRequestsArray = [Request]()
        super.init(aucId: aucId, userName: userName, password: password, mobile: mobile)
    }
    
    //initializer without predefined paramaters EPL PUL
    override init(aucId: String, userName: String, password: String, mobile: NSNumber) {
        pickUpRequestsArray = [Request]()
        super.init(aucId: aucId, userName: userName, password: password, mobile: mobile)
    }
    //MARK:Setters
    func setEstimatedPickUpTime(ept: NSDate){
        estimatedPickUpTime = ept
    }
    func setPickUpLocation(pul: CLLocation){
        pickUpLocation = pul
    }
    //MARK:Getters
    func getEstimatedPickUpTime()->NSDate?{
        return estimatedPickUpTime
    }
    
    func getPickUpLocation()->CLLocation?{
        return pickUpLocation
    }
    //MARK:Request Handlers
    func updateRideRequests(){
        
    }
    func processRideRequestAtIndex(){
        
    }
    
}