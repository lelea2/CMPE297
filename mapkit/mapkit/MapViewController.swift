//
//  MapViewController.swift
//
//  Created by Dao, Khanh on 11/21/16.
//  Copyright © 2016 cmpe297. All rights reserved.
//

import Foundation
import UIKit
import MapKit

//How to know where user are
import CoreLocation

class MapViewController: UIViewController {

    @IBOutlet var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}