//
//  ExploreVC.swift
//  CarPooling
//
//  Created by Badr AlKhamissi on 12/26/15.
//  Copyright © 2015 Badr AlKhamissi. All rights reserved.
//

import Foundation
import UIKit
import Parse
import MapKit

class ExploreVC : UIViewController,MKMapViewDelegate, CLLocationManagerDelegate {
    
    //Outlet for MapView
    @IBOutlet weak var mapView: MKMapView!
    
    //Array of Pins denoting pickup locations, this class conforms to MKAnotations allowing it to be added to the MapView
    var pickLocations = [PickUpPin]()
    
    //Location manager object used to aquire current position
    let locManager = CLLocationManager()
    
    /*
    - Determining desired accuracy for finding current location
    - Determines how sensative the manager object is to changes in current position
    - Request user authorization for finding current location
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true;
        mapView.delegate = self
        locManager.delegate = self
        locManager.desiredAccuracy=kCLLocationAccuracyBest;
        locManager.distanceFilter=kCLDistanceFilterNone;
        locManager.requestWhenInUseAuthorization() //If authorization not given user must turn on location services for app in settings
    }

    /*
    - This Function is called when the locationManager object determines current position
    - Specifies desired region paramaters that the mapView will initially center on
    - Stop location updating in order to prevent this function from being called again unnecessarily
    - fetches locations data from servers
    */
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        let regionRadius : CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: false)
        locManager.stopUpdatingLocation()
        fetchPinsFromServerAtLocation(newLocation)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        let aucLocation = CLLocation(latitude: 30.0195683, longitude: 31.502691)
        let regionRadius : CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(aucLocation.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: false)
        locManager.startUpdatingLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    /*
    - A query is instantiated that searches in the PickUpSpots class on parse
    - Restrict query to retrieve entries that are within a 3 km radius for initial location
    - Included data in "driver" key which contains pointers to entries of type User class on parse
    - Retrieved data is in the form of an Array of dirctionaries of type key String and Data AnyObject
    - Data in each dictionary object is casted to it's respective type and is used to form a pickUpPin Object
    - After parsing all the data into an array of pickUpPins all the pickUpPins are drawn into the MapView
     */
    
    func fetchPinsFromServerAtLocation(newLocation: CLLocation){
        
        dispatch_async(dispatch_get_main_queue()){
            
            let query = PFQuery(className: "PickUpSpots")
            query.whereKey("pickUpLocation", nearGeoPoint: PFGeoPoint(location: newLocation), withinKilometers: 3)
            query.includeKey("driver")
            
            query.findObjectsInBackgroundWithBlock {
                
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    // The find succeeded.
                    print("Successfully retrieved \(objects!.count) scores.")
                    // Do something with the found objects
                    if let allObjects = objects {
                        for eachObject in allObjects {
                            let pickUpCoordinates = CLLocationCoordinate2D(latitude: (eachObject["pickUpLocation"] as! PFGeoPoint).latitude, longitude: (eachObject["pickUpLocation"] as! PFGeoPoint).longitude)
                            let pickUpTime = eachObject["pickUpTime"] as! String
                            let driverInfo = eachObject["driver"] as! PFUser
                            let driverName:String = driverInfo.username!
                            let driverMobile:String = driverInfo["Mobile"] as! String
                            let driverID:String = driverInfo["AUCID"] as! String
                            let pickUpPoint = PickUpPin(coordinate: pickUpCoordinates, pickUpTime: pickUpTime, driverName: driverName, driverMobile: driverMobile, driverID: driverID)
                            self.pickLocations.append(pickUpPoint)
                        }
                        
                        self.mapView.addAnnotations(self.pickLocations)
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        }

    }
    
}


