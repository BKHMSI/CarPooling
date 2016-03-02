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
    @IBOutlet weak var mapViewTypeSegment: UISegmentedControl!
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    //Array of Pins denoting pickup locations, this class conforms to MKAnotations allowing it to be added to the MapView
    var pickLocations = [PickUpPin]()
    
    var selectedPin = (String,String)("","")
    
    //Location manager object used to aquire current position
    let locManager = CLLocationManager()
    
    /*
    - Determining desired accuracy for finding current location
    - Determines how sensative the manager object is to changes in current position
    - Request user authorization for finding current location
    */
    
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.hidden = true
        activityIndicator.hidesWhenStopped = true
        mapView.showsUserLocation = true;
        mapView.delegate = self
        locManager.delegate = self
        locManager.desiredAccuracy=kCLLocationAccuracyBest;
        locManager.distanceFilter=kCLDistanceFilterNone;
        locManager.requestWhenInUseAuthorization() //If authorization not given user must turn on location services for app in settings
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    /*
    - This Function is  called when the locationManager object determines current position
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
        gotToCampus()
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
            
            query.whereKey("Location", nearGeoPoint: PFGeoPoint(location: newLocation), withinKilometers: 6)
            
            query.includeKey("driver")
            
            query.findObjectsInBackgroundWithBlock {
                
                (objects: [PFObject]?, error: NSError?) -> Void in
                
                if error == nil {
                    print("Successfully retrieved \(objects!.count) scores.")
                    if let allObjects = objects {
                        for eachObject in allObjects {
                            self.pickLocations.append(eachObject.convertPFObjectToPickUpPin())
                        }
                        
                        self.mapView.addAnnotations(self.pickLocations)
                    }
                } else {
                    // Log details of the failure
                    print("Error: \(error!) \(error!.userInfo)")
                }
            }
            self.activityIndicator.stopAnimating()
        }

    }
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        if let annotation = annotation as? PickUpPin {
            let identifier = "pin"
            var view: MKPinAnnotationView
            if let dequeuedView = mapView.dequeueReusableAnnotationViewWithIdentifier(identifier)
                as? MKPinAnnotationView {
                    dequeuedView.annotation = annotation
                    view = dequeuedView
            } else {
                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                view.canShowCallout = true
                view.calloutOffset = CGPoint(x: -5, y: 5)
                view.rightCalloutAccessoryView = UIButton(type: .ContactAdd) as UIView
                view.rightCalloutAccessoryView = UIButton(type: .InfoLight) as UIView
            }
            return view
        }
        return nil
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        selectedPin = ((view.annotation?.title!)!, ((view.annotation?.subtitle)!)!)
        self.performSegueWithIdentifier("goToRideCardSegue", sender: self)

    }
    
    func gotToCampus(){
        let aucLocation = CLLocation(latitude: 30.0195683, longitude: 31.502691)
        let regionRadius : CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(aucLocation.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: false)
        locManager.startUpdatingLocation()
    }
    
    @IBAction func changeMapType(sender: AnyObject) {
        let type = mapViewTypeSegment.selectedSegmentIndex
        mapView.mapType = type == 1 ? MKMapType.Satellite:MKMapType.Standard
    }
    
    @IBAction func goToCampusBtnPressed(sender: AnyObject) {
        gotToCampus()
    }
    
    @IBAction func refreshExploreMap(sender: AnyObject) {
        // Updates Location then Fetches Pins
        activityIndicator.hidden = false
        activityIndicator.startAnimating()
        locManager.startUpdatingLocation()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goToRideCardSegue"){
            let vc = segue.destinationViewController as! CardRideVC
            vc.name = selectedPin.0
            vc.time = selectedPin.1
        }
    }
    
    @IBAction func unwindToExploreVC(segue: UIStoryboardSegue){

    }
}


