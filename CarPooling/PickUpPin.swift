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

class PickUpPin: NSObject, MKAnnotation {

    var coordinate: CLLocationCoordinate2D
    var pickUpTime: String
    var driverName:String
    var driverMobile:String
    var driverID: String
    
    var title:String?{
        let range = driverName.rangeOfString("@aucegypt.edu")
        if let range = range {
            driverName.removeRange(range)
        }
        return driverName
    }
    var subtitle:String?{
        return  "At: \(pickUpTime), Cell: \(driverMobile)"
    }
    
    init(coordinate: CLLocationCoordinate2D, pickUpTime: String, driverName:String, driverMobile:String, driverID: String){
        self.coordinate = coordinate
        self.pickUpTime = pickUpTime
        self.driverName = driverName
        self.driverMobile = driverMobile
        self.driverID = driverID
        super.init()
    }
    
    func savePinToParse(){
        let location = PFGeoPoint(latitude: coordinate.latitude, longitude: coordinate.longitude)
        let pin = PFObject(className: "PickUpSpots")
        pin["pickUpLocation"] = location
        pin["pickUpTime"] = pickUpTime
        let currentUser = PFUser(withoutDataWithObjectId: PFUser.currentUser()?.objectId)
        pin["driver"] = currentUser
        pin.saveInBackgroundWithBlock({
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                // The object has been saved.
            } else {
                // There was a problem, check error.description
            }
        })
    }
}
