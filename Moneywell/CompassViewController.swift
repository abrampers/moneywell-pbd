//
//  CompassViewController.swift
//  Moneywell
//
//  Created by Faza Fahleraz on 25/02/19.
//  Copyright © 2019 Abram Situmorang. All rights reserved.
//

import UIKit
import CoreLocation

class CompassViewController: UIViewController {

    @IBOutlet weak var compassImage: UIImageView!
    @IBOutlet weak var locationStatusLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var locationLabelSpinner: UIActivityIndicatorView!
    
    let locationDelegate = LocationDelegate()
    var currentLocation: CLLocation? = nil
    var targetLocationBearing: CGFloat { return currentLocation?.bearingToLocationRadian(self.targetLocation) ?? 0 }
    var targetLocation: CLLocation = CLLocation(latitude: 21.422684, longitude: 39.826192)
    
    let locationManager: CLLocationManager = {
        $0.requestWhenInUseAuthorization()
        $0.desiredAccuracy = kCLLocationAccuracyBest
        $0.startUpdatingLocation()
        $0.startUpdatingHeading()
        $0.startMonitoringSignificantLocationChanges()
        return $0
    }(CLLocationManager())
    
    private func orientationAdjustment() -> CGFloat {
        let isFaceDown: Bool = {
            switch UIDevice.current.orientation {
            case .faceDown: return true
            default: return false
            }
        }()
        
        let adjAngle: CGFloat = {
            switch UIApplication.shared.statusBarOrientation {
            case .landscapeLeft:  return 90
            case .landscapeRight: return -90
            case .portrait, .unknown: return 0
            case .portraitUpsideDown: return isFaceDown ? 180 : -180
            }
        }()
        return adjAngle
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = locationDelegate
        
        locationDelegate.locationCallback = { location in
            self.currentLocation = location
            self.requestCurrentLocationAddress()
        }
        
        locationDelegate.headingCallback = { newHeading in
            func computeNewAngle(with newAngle: CGFloat) -> CGFloat {
                let heading: CGFloat = {
                    let originalHeading = self.targetLocationBearing - newAngle.degreesToRadians
                    switch UIDevice.current.orientation {
                    case .faceDown: return -originalHeading
                    default: return originalHeading
                    }
                }()
                return CGFloat(self.orientationAdjustment().degreesToRadians + heading)
            }
            
            UIView.animate(withDuration: 0.5) {
                let angle = computeNewAngle(with: CGFloat(newHeading))
                self.compassImage.transform = CGAffineTransform(rotationAngle: angle)
            }
        }
        
        self.locationLabel.isHidden = true
        self.locationLabelSpinner.startAnimating()
    }
    
    func requestCurrentLocationAddress() {
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(self.currentLocation!) { placemarks, error in
            
            guard error == nil else {
                print("⚠️ Error in \(#function): \(error!.localizedDescription)")
                return
            }
            
            guard let placemark = placemarks?[0] else {
                print("⚠️ Error in \(#function): placemark is nil")
                return
            }
            
            self.updateLocationLabel(withPlacemark: placemark)
            
            let timeZone = placemark.timeZone?.abbreviation()!
            let email = UserDefaults.user?.email
            let locationUpdateRequestURL = "http://3.1.35.180/api/timeSetting?lat=\(self.currentLocation!.coordinate.latitude)&lng=\(self.currentLocation!.coordinate.longitude)&timezone=\(timeZone ?? "GMT+7")&email=\(email ?? "")"
            let locationUpdateRequest = HTTPRequest(url: locationUpdateRequestURL, completionHandler: {(_: [String: Any]) -> Void in })
            locationUpdateRequest.resume()
            
            print(email)
        }
    }
    
    func updateLocationLabel(withPlacemark placemark: CLPlacemark) {
        var output = ""
        if let town = placemark.locality {
            output = output + "\(town), "
        }
        if let state = placemark.administrativeArea {
            output = output + "\(state), "
        }
        if let country = placemark.country {
            output = output + "\(country)"
        }
        self.locationLabelSpinner.stopAnimating()
        self.locationLabel.text = output
        self.locationLabel.isHidden = false
        self.locationStatusLabel.text = "Heading to Mecca from"
    }
}
