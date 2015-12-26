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
    
    //Location at which passenger currently is (helps coordination with driver)
    private var currentLocation : CLLocation?
    
    //Array of Requests made which include requests that are still pending/approved/rejected
    private var rideRequestsArray : [Request]
    
    //Number of accepted requests, is updated in background with property observer for increased functionality
    private var rideRequestsAccepted : Int = 0{
        willSet(newNumber){
        }
    }
    
    //MARK: Initialisers

    //initializer with predefined location
    init(aucId: String, userName: String, password: String, mobile: NSNumber, currentLocation:CLLocation) {
        rideRequestsArray = [Request]()
        self.currentLocation = currentLocation
        super.init(aucId: aucId, userName: userName, password: password, mobile: mobile)
    }
    
    //initializer with undefined location
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
