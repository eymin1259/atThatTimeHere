//
//  NoteViewModel.swift
//  atThatTimeHere
//
//  Created by yongmin lee on 8/26/21.
//

import UIKit
import CoreLocation

struct NoteViewModel {
    
    //MARK: properties
    var isNewNote : Bool = false
    var isEditiing : Bool = false
    var isNoteWithPhoto : Bool = false
//    var title
//    var photo
//    var content
    
    var noteImage : UIImage?
    var noteImageUrl : URL?
    var locationManager = CLLocationManager()
    var currentLocation : CLLocation?
    
    //MARK: methods
    
    func startLocationUpdate() {
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    func stopLocationUpdate(){
        locationManager.stopMonitoringSignificantLocationChanges()
        locationManager.stopUpdatingLocation()
    }
}
