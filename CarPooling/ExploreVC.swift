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
    
    @IBOutlet weak var mapView: MKMapView!
    
    var pickLocations = [PickUpPin]()
    let locManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.showsUserLocation = true;
        mapView.delegate = self
        locManager.delegate = self
        locManager.desiredAccuracy=kCLLocationAccuracyBest;
        locManager.distanceFilter=kCLDistanceFilterNone;
        locManager.requestWhenInUseAuthorization()
    }

    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        let regionRadius : CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: false)
        locManager.stopUpdatingLocation()
        
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
                    if let objects = objects {
                        for object in objects {
                            let pickUpCoordinates = CLLocationCoordinate2D(latitude: (object["pickUpLocation"] as! PFGeoPoint).latitude, longitude: (object["pickUpLocation"] as! PFGeoPoint).longitude)
                            let pickUpTime = object["pickUpTime"] as! String
                            let driverInfo = object["driver"] as! PFUser
                            let driverName:String = driverInfo.username!
                            let driverMobile:String = driverInfo["Mobile"] as! String
                            let driverID:String = driverInfo["AUCID"] as! String
                            let pickUpPoint = PickUpPin(coordinate: pickUpCoordinates, pickUpTime: pickUpTime, driverName: driverName, driverMobile: driverMobile, driverID: driverID)
                            self.pickLocations.append(pickUpPoint)
                        }
                        
                        self.mapView.addAnnotations(self.pickLocations)
                        print(PFUser.currentUser()?.objectId)
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
        }
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
    
}


