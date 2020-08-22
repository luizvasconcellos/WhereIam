//
//  ViewController.swift
//  Where I am
//
//  Created by Luiz Vasconcellos on 17/04/20.
//  Copyright © 2020 Luiz Vasconcellos. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var speedLabel: UILabel!
    @IBOutlet weak var latitudeLabel: UILabel!
    @IBOutlet weak var longitudeLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        speedLabel.clipsToBounds = true
        speedLabel.layer.cornerRadius = 35
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations.last
        guard let latitude = userLocation?.coordinate.latitude else {return}
        guard let longitude = userLocation?.coordinate.longitude else {return}
        guard let speed = userLocation?.speed else {return}
        
        let deltaLat: CLLocationDegrees = 0.01
        let deltaLong: CLLocationDegrees = 0.01
        
        let location:CLLocationCoordinate2D = CLLocationCoordinate2DMake(latitude, longitude)
        let viewArea: MKCoordinateSpan = MKCoordinateSpan.init(latitudeDelta: deltaLat, longitudeDelta: deltaLong)
        
        let region: MKCoordinateRegion = MKCoordinateRegion.init(center: location, span: viewArea)
        CLGeocoder().reverseGeocodeLocation(userLocation!) { (locationDetail, error) in
            if error == nil {
                if let localData = locationDetail?.first {
                    var street = ""
                    if localData.thoroughfare != nil {
                        street = localData.thoroughfare!
                    }
                    
                    var number = ""
                    if localData.subThoroughfare != nil {
                        number = localData.subThoroughfare!
                    }
                    
                    var city = ""
                    if localData.subThoroughfare != nil {
                        city = localData.locality!
                    }
                    
                    var neighborhood = ""
                    if localData.subLocality != nil {
                        neighborhood = localData.subLocality!
                    }
                    
                    var postalCode = ""
                    if localData.postalCode != nil {
                        postalCode = localData.postalCode!
                    }
                    
                    var country = ""
                    if localData.country != nil {
                        country = localData.country!
                    }
                    
                    var state = ""
                    if localData.administrativeArea != nil {
                        state = localData.administrativeArea!
                    }
                    
                    var subAdministrativeArea = ""
                    if localData.subAdministrativeArea != nil {
                        subAdministrativeArea = localData.subAdministrativeArea!
                    }
                    
                    self.addressLabel.text = street + " - "
                                             + number + " / "
                                             + city + " / "
                                             + country
                }
            } else {
                print(error)
            }
        }
        
        mapView.setRegion(region, animated: true)
        
        self.latitudeLabel.text = String(latitude)
        self.longitudeLabel.text = String(longitude)
        if speed > 0 {
           self.speedLabel.text = String(Int((speed * 3.6)))
        } else {
            self.speedLabel.text = "0"
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status != .authorizedWhenInUse {
            let alert = UIAlertController(title: "Location Authorize",
                                          message: "App need permission to access your location.",
                                          preferredStyle: .alert)
            let settinigsAction = UIAlertAction(title: "Open configuration", style: .default) { (settingsAlert) in
                if let settings = NSURL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(settings as URL)
                }
            }
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            
            alert.addAction(settinigsAction)
            alert.addAction(cancelAction)
            present(alert, animated: true, completion: nil)
        }
    }


}

