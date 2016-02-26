//
//  PickUpPin.swift
//  CarPooling
//
//  Created by Ali Sultan on 1/3/16.
//  Copyright © 2016 Badr AlKhamissi. All rights reserved.
//

import Foundation
import MapKit
import Parse

/*
class must confrom to MKAnnotation protocol in order for annotations to be drawn on the map
*/

extension Int{
    func secToTime()->String{
        // Seconds:  \((self % 3600) % 60)
         return "\((self / 3600 )):\((self % 3600) / 60)"
    }
}

extension PFObject{
    /**
    Incredibly Dangerous if object is NOT a PickUpPin
    */
    func convertPFObjectToPickUpPin()->PickUpPin{
        let eachObject = self
        let pickUpCoordinates = CLLocationCoordinate2D(latitude: (eachObject["Location"] as! PFGeoPoint).latitude, longitude: (eachObject["Location"] as! PFGeoPoint).longitude)
        let day = eachObject["Day"] as! String
        let time = (eachObject["TimeInSeconds"] as! Int).secToTime()
        let pickUpTime = "\(day) \(time)"
//        let driverInfo = eachObject["driver"] as! PFUser
//        let driverName:String = driverInfo.username!
//        let driverMobile:String = driverInfo["Mobile"] as! String
//        let driverID:String = driverInfo["AUCID"] as! String
        let driverName:String = "Badr AlKhamissi"
        let driverMobile:String = "+201006520789"
        let driverID:String = "900141572"

        return PickUpPin(coordinate: pickUpCoordinates, pickUpTime: pickUpTime, driverName: driverName, driverMobile: driverMobile, driverID: driverID)
    }
}

extension String{
    func toInt()->Int{
        return Int(self)!
    }
}

class PickUpPin: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var pickUpTime: String
    var driverName:String
    var driverMobile:String
    var driverID: String
    
    var title:String?{
        return driverName
    }
    
    var subtitle:String?{
        return  "\(pickUpTime)"
    }
    
    init(coordinate: CLLocationCoordinate2D, pickUpTime: String, driverName:String, driverMobile:String, driverID: String){
        self.coordinate = coordinate
        self.pickUpTime = pickUpTime
        self.driverName = driverName
        self.driverMobile = driverMobile
        self.driverID = driverID
        super.init()
    }
    
    func savePinToParseAsPickUpPinAndConnectItToUserWithCurrentUser(){
        
        let location = PFGeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let DateAndTimeArray = pickUpTime.componentsSeparatedByString(" ")
        let day = DateAndTimeArray[0]
        let time = DateAndTimeArray[1].toInt()
        let pin = PFObject(className: "PickUpSpots")
        let currentUserPointer = PFUser(withoutDataWithObjectId: PFUser.currentUser()?.objectId)

        pin["Location"] = location
        pin["TimeInSeconds"] = time
        pin["Day"] = day
        pin["driver"] = currentUserPointer
        
        pin.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                //connectUser
                let currentUserReference = PFUser.currentUser()
                currentUserPointer.addObject(pin, forKey: "PickUpSchedule")
                currentUserPointer.saveInBackground()
            } else {
                // There was a problem, check error.description
            }
        })
    }
    
    func savePinToParseAsDropOffPinAndConnectItToUserWithCurrentUser(){
        
        let location = PFGeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let DateAndTimeArray = pickUpTime.componentsSeparatedByString(" ")
        let day = DateAndTimeArray[0]
        let time = DateAndTimeArray[1].toInt()
        let pin = PFObject(className: "DropOffSpots")
        let currentUserPointer = PFUser(withoutDataWithObjectId: PFUser.currentUser()?.objectId)
        
        pin["Location"] = location
        pin["TimeInSeconds"] = time
        pin["Day"] = day
        pin["driver"] = currentUserPointer
        
        pin.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                //connectUser
                let currentUserReference = PFUser.currentUser()
                currentUserPointer.addObject(pin, forKey: "DropOffSchedule")
                currentUserPointer.saveInBackground()
            } else {
                // There was a problem, check error.description
            }
        })
    }

 
}
