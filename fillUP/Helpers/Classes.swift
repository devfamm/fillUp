//
//  Classes.swift
//  fillUp
//
//  Created by user245588 on 11/27/23.
//

import Foundation
import UIKit
import CoreLocation
import CoreLocationUI

//Location Manager Class.v
class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    let manager = CLLocationManager()

    @Published var location: CLLocationCoordinate2D?

    override init() {
        super.init()
        manager.delegate = self
    }

    func requestLocation() {
        manager.startUpdatingLocation()
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        location = locations.first?.coordinate
        print("Locations:", location!)
        manager.stopUpdatingLocation()
    }
    //Failed Handler.
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //Print the error.
        print(error.localizedDescription)
    }
}
