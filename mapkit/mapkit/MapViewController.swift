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

class MapViewController: UIViewController, MKMapViewDelegate {

    //Display string for address map
    var fromPlace = ""
    var toPlace = ""
    var showType = "" //either "map" or "route"
    var geocoder = CLGeocoder()
    var places = [String]()

    @IBOutlet var mapView: MKMapView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //if showType == "map" {
        print("fromPlace = " + fromPlace)
        print("toPlace = " + toPlace)
        if (!fromPlace.isEmpty) {
            places.append(fromPlace)
        }
        if (!toPlace.isEmpty) {
            places.append(toPlace)
        }
        print(places.count)
        mapPlot(places) //Map plots

        if showType == "route" {
            
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    //Helper function to map plot on map
    func mapPlot(places:[String]) {
        var i = 1
        var coordinates: CLLocationCoordinate2D?
        var placemark: CLPlacemark?
        var annotation: Station?
        var stations:Array = [Station]()

        for address in places {
//            geocoder = CLGeocoder() //new geocoder
            geocoder.geocodeAddressString(address, completionHandler: {(placemarks, error) -> Void in
                if((error) != nil)  {
                    print("Error", error)
                }
                placemark = placemarks?.first
                if placemark != nil {
                    coordinates = placemark!.location!.coordinate
                    print("locations = \(coordinates!.latitude) \(coordinates!.longitude)")
                    annotation = Station(latitude: coordinates!.latitude, longitude: coordinates!.longitude, address: address)
                    stations.append(annotation!)
                    if (i == self.places.count) {
                        self.mapView.addAnnotations(stations)
//                        let region = MKCoordinateRegionMakeWithDistance(coordinates!, 5000.0, 7000.0)
//                        self.mapView.setRegion(region, animated: true)
                    }
                    i++
                }
            })
        }
    }

    class Station: NSObject, MKAnnotation {
        var title: String?
        var latitude: Double
        var longitude:Double

        var coordinate: CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }

        init(latitude: Double, longitude: Double, address: String) {
            self.latitude = latitude
            self.longitude = longitude
            self.title = address
        }
    }
}

