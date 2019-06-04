//
//  LocationService.swift
//  ios-code-challenge
//
//  Created by Rudy Matos on 6/3/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject{
    
    var getCurrentLocationCompletion : ((Result<(latitude:CLLocationDegrees, longitude:CLLocationDegrees), CCError>) -> Void)?
    static let main = LocationService()

    lazy var locationManager: CLLocationManager? = {
        return CLLocationManager()
    }()
    
    private override init(){
        super.init()
    }
    
}

extension LocationService{
    
    func getCurrentLocation(){
        if CLLocationManager.locationServicesEnabled() {
            if CLLocationManager.authorizationStatus() == .restricted || CLLocationManager.authorizationStatus() == .denied || CLLocationManager.authorizationStatus() == .notDetermined{
                locationManager?.requestWhenInUseAuthorization()
            }
            locationManager?.desiredAccuracy = kCLLocationAccuracyBest
            locationManager?.delegate = self
            locationManager?.startUpdatingLocation()
        }else{
            let error = CCError(message: "Error getting Location Services. Make sure to turn your GPS On.", type: .errorGettingLocationData)
            getCurrentLocationCompletion?(.failure(error))
        }
    }
}

extension LocationService: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let error = CCError(message: "Error getting Location Services. \(error.localizedDescription)).", type: .errorGettingLocationData)
        getCurrentLocationCompletion?(.failure(error))
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.locationManager?.stopUpdatingLocation()
        self.locationManager?.delegate = nil
        guard let coordinates = locations.first?.coordinate else {
            let error = CCError(message: "Error getting Location Services. Invalid Coordinates.", type: .errorGettingLocationData)
            getCurrentLocationCompletion?(.failure(error))
            return
        }
        
        getCurrentLocationCompletion?(.success((latitude:coordinates.latitude, longitude: coordinates.longitude)))
    }
    
}
