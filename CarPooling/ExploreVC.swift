//
//  ExploreVC.swift
//  CarPooling
//
//  Created by Badr AlKhamissi on 12/26/15.
//  Copyright © 2015 Badr AlKhamissi. All rights reserved.
//

import UIKit
import MapKit

class ExploreVC : UIViewController {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var user:User?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
}