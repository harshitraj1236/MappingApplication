//
//  LocationManager.swift
//  MappingApplication
//
//  Created by Harshit Raj on 09/06/26.
//

import Foundation
import Combine
import CoreLocation

final class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    // Data to store
    @Published var latitude: Double = 0.0
    @Published var longitude: Double = 0.0
    @Published var authorizationStatus: CLAuthorizationStatus?
    
    // configure location service to application
    private let locationManager = CLLocationManager()
    
    // surpass the use of the parent class
    override init() {
        super.init()
        //initialization
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = 10
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        
        requestLocation()
        
    }
    
    // location permission in background
    private func requestLocation() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    // location updates
    func startTracking() {
        locationManager.startUpdatingLocation()
    }
    func stopTracking() {
        locationManager.stopUpdatingLocation()
    }
    
    // CLLocationManagerDelegate
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let latestLocation = locations.last
        else{
            return
        }
        
        DispatchQueue.main.async {
            self.latitude = latestLocation.coordinate.latitude
            self.longitude = latestLocation.coordinate.longitude
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        
        authorizationStatus = status
        
        switch status {
        case .authorizedAlways, .authorizedWhenInUse:
            startTracking()
        
        case .denied:
            print("Location access denied")
        case .restricted:
            print("Location access restricted")
            
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Location error: \(error.localizedDescription)")
    }
}
