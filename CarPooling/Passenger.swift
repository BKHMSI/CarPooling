//
//  Passenger.swift
//  CarPooling
//
//  Created by Ali Sultan on 12/26/15.
//  Copyright © 2015 Badr AlKhamissi. All rights reserved.
//

import Foundation
import MapKit

class Passenger : User {
    
    //MARK: Properties
    
    private var currentLocation : CLLocation?
    private var rideRequestsArray : [Request]
    
    
    private var rideRequestsAccepted : Int = 0{
        willSet(newNumber){
        }
    }
    
    //MARK: Initialisers

    init(aucId: String, userName: String, password: String, mobile: NSNumber, currentLocation:CLLocation) {
        rideRequestsArray = [Request]()
        self.currentLocation = currentLocation
        super.init(aucId: aucId, userName: userName, password: password, mobile: mobile)
    }
    
    override init(aucId: String, userName: String, password: String, mobile: NSNumber) {
        rideRequestsArray = [Request]()
        super.init(aucId: aucId, userName: userName, password: password, mobile: mobile);
    }
    
    //MARK: Setters
    func setCurrentLocation(){
        
    }
    
    //MARK: Getters
    
    func getCurrentLocation(){
    
    }
    
    //MARK: Request Handlers
    func updateRideRequests(){
    
    }
    func processRideRequestAtIndex(){
    
    }
}
