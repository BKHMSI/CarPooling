//
//  DriverVC.swift
//  CarPooling
//
//  Created by Ali Sultan on 1/3/16.
//  Copyright © 2016 Badr AlKhamissi. All rights reserved.
//

import UIKit
import MapKit
import Parse
class DriverVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UISearchBarDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var currentLocation = CLLocationCoordinate2D()
    let locManager = CLLocationManager()
    var searchController:UISearchController!
    var localSearchRequest:MKLocalSearchRequest!
    var localSearch:MKLocalSearch!
    var localSearchResponse:MKLocalSearchResponse!
    var error:NSError!
    var pointAnnotation:MKPointAnnotation!
    var pinAnnotationView:MKPinAnnotationView!
    
    override func viewDidLoad() {
        let value = UIInterfaceOrientation.LandscapeLeft.rawValue
        UIDevice.currentDevice().setValue(value, forKey: "orientation")
        super.viewDidLoad()
        mapView.showsUserLocation = true;
        mapView.delegate = self
        locManager.delegate = self
        locManager.desiredAccuracy=kCLLocationAccuracyBest;
        locManager.distanceFilter=kCLDistanceFilterNone;
        locManager.requestWhenInUseAuthorization()
        let addPinAtLongPress = UILongPressGestureRecognizer(target: self, action: Selector("dropPin:"))
        addPinAtLongPress.minimumPressDuration = 1
        mapView.addGestureRecognizer(addPinAtLongPress)
        pointAnnotation = MKPointAnnotation()
        pinAnnotationView = MKPinAnnotationView(annotation: pointAnnotation, reuseIdentifier: nil)
    }
    
    func dropPin(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state != UIGestureRecognizerState.Began {
            return
        }else{
            mapView.removeAnnotation(pointAnnotation)
            let touchPoint : CGPoint = gestureRecognizer.locationInView(mapView)
            pointAnnotation.coordinate = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            CLGeocoder().reverseGeocodeLocation(CLLocation(latitude: pointAnnotation.coordinate.latitude, longitude: pointAnnotation.coordinate.longitude), completionHandler: {(placemarks, error) -> Void in
                if error != nil {
                    print("Reverse geocoder failed with error" + error!.localizedDescription)
                    return
                }
                if placemarks!.count > 0 {
                    let pm = placemarks![0]
                    if let unwrappedStreetName = pm.thoroughfare {
                        self.pointAnnotation.title = unwrappedStreetName
                    }else {
                        if let unwrappwedLocationName = pm.name {
                            self.pointAnnotation.title = unwrappwedLocationName
                        }
                        else {
                            self.pointAnnotation.title = "Can't determine Location"
                        }
                    }
                }
                else {
                    print("Problem with the data received from geocoder")
                }
            })
            mapView.addAnnotation(pinAnnotationView.annotation!)
        }
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar){
        
        searchBar.resignFirstResponder()
        dismissViewControllerAnimated(true, completion: nil)
        mapView.removeAnnotation(pointAnnotation)
        localSearchRequest = MKLocalSearchRequest()
        localSearchRequest.naturalLanguageQuery = searchBar.text
        localSearchRequest.region.center = currentLocation
        localSearchRequest.region.span = MKCoordinateSpan(latitudeDelta: 1, longitudeDelta: 1)
        localSearch = MKLocalSearch(request: localSearchRequest)
        localSearch.startWithCompletionHandler { (localSearchResponse, error) -> Void in
            
            if localSearchResponse == nil{
                let alertController = UIAlertController(title: nil, message: "Place Not Found", preferredStyle: UIAlertControllerStyle.Alert)
                alertController.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alertController, animated: true, completion: nil)
                return
            }
            self.pointAnnotation.title = searchBar.text
            self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: localSearchResponse!.boundingRegion.center.latitude, longitude:localSearchResponse!.boundingRegion.center.longitude)
            self.mapView.centerCoordinate = self.pointAnnotation.coordinate
            self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        }
    }
    
    @IBAction func finalizeDefaultLocation(sender: AnyObject) {
        if searchController != nil {
            if searchController.isBeingPresented() {
                searchController.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        performSegueWithIdentifier("goToScheduleSegue", sender: self)
    }
    
    @IBAction func showSearchBar(sender: AnyObject) {
        searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        presentViewController(searchController, animated: true, completion: nil)
    }

    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        currentLocation = newLocation.coordinate
        self.pointAnnotation.title = "Current Location"
        self.pointAnnotation.coordinate = CLLocationCoordinate2D(latitude: newLocation.coordinate.latitude, longitude:     newLocation.coordinate.longitude)
        self.mapView.centerCoordinate = self.pointAnnotation.coordinate
        self.mapView.addAnnotation(self.pinAnnotationView.annotation!)
        locManager.stopUpdatingLocation()
    }

    override func viewWillAppear(animated: Bool) {
        let aucLocation = CLLocation(latitude: 30.0195683, longitude: 31.502691)
        let regionRadius : CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(aucLocation.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: false)
        locManager.startUpdatingLocation()
        if UIDevice.currentDevice().valueForKey("orientation") as! Int != UIInterfaceOrientation.LandscapeLeft.rawValue {
            UIDevice.currentDevice().setValue(UIInterfaceOrientation.LandscapeLeft.rawValue, forKey: "orientation")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goToScheduleSegue"){
            let pickUpScheduleVC = segue.destinationViewController as! PickUpScheduleVC
            pickUpScheduleVC.defaultLocation = self.pointAnnotation.coordinate
        }
    }


}
