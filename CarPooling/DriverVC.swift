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
class DriverVC: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    var pin : PickUpPin?
    let locManager = CLLocationManager()
    var lastRegion = MKCoordinateRegion()
    var pinLocation:CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    override func viewDidLoad() {
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
    }
    
    func dropPin(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state != UIGestureRecognizerState.Began {
            return
        }else{
            let alertController = UIAlertController(title: "Please sepcifiy when you want",
                message: nil,
                preferredStyle: UIAlertControllerStyle.Alert
            )
            alertController.addAction(UIAlertAction(title: "Send",
                style: UIAlertActionStyle.Default,
                handler: { alertController in print("Send Request")})
            )
            alertController.addAction(UIAlertAction(title: "Cancel",
                style: UIAlertActionStyle.Default,
                handler: nil)
            )
            
            let touchPoint : CGPoint = gestureRecognizer.locationInView(mapView)
            pinLocation = mapView.convertPoint(touchPoint, toCoordinateFromView: mapView)
            pin = PickUpPin(coordinate: pinLocation, pickUpTime: "Temp", driverName: "Temp", driverMobile: "", driverID: "")
            mapView.addAnnotation(pin!)
        }
    }
    
    @IBAction func saveToDataToParse(sender: AnyObject) {
        pin?.savePinToParse()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateToLocation newLocation: CLLocation, fromLocation oldLocation: CLLocation) {
        let regionRadius : CLLocationDistance = 1000
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(newLocation.coordinate,regionRadius * 2.0, regionRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: false)
        locManager.stopUpdatingLocation()
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
    
    
    @IBAction func nextBtnPressed(sender: AnyObject) {
        self.performSegueWithIdentifier("goToScheduleSegue", sender: self)
    }
    
    
    /*
    TODO: 
    Construct annotation object - DONE!
    figure out drop mechanism
    save annotation object to PF - DONE! 
    */

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if(segue.identifier == "goToScheduleSegue"){
            let pickUpScheduleVC = segue.destinationViewController as! PickUpScheduleVC
            pickUpScheduleVC.defaultLocation = pinLocation
            
        }
    }


}
