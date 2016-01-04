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
    private var estimatedPickUpTime:NSDate // EPT
    private var pickUpLocation:CLLocation // PUL
    
    
    init(aucId:String, userName:String, password:String, mobile:NSNumber, ept:NSDate, pul:CLLocation){
        estimatedPickUpTime = ept // Estimated PickUp Time
        pickUpLocation = pul // Pick Up Location
        super.init(aucId: aucId, userName: userName, password: password, mobile: mobile)
    }
    
    func setEPT(ept: NSDate){
        estimatedPickUpTime = ept
    }
    
    func setPUL(pul: CLLocation){
        pickUpLocation = pul
    }
    
    func getEPT()->NSDate{
        return estimatedPickUpTime
    }
    
    func getPUL()->CLLocation{
        return pickUpLocation
    }

}