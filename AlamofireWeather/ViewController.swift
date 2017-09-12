//
//  ViewController.swift
//  AlamofireWeather
//
//  Created by Guilherme Crozariol on 2017-09-12.
//  Copyright © 2017 Guilherme Crozariol. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    @IBOutlet weak var map: MKMapView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    let manager = CLLocationManager()
    var latitude: Double = 0.0
    var longitude: Double = 0.0

    let forecastAPIKey = "1a76140f482b5b57207166d39b0b4217"
    var forecastService: ForecastService!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        let location = locations[0]
        let myLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude)
        let span: MKCoordinateSpan = MKCoordinateSpanMake(0.01, 0.01)
        let region: MKCoordinateRegion = MKCoordinateRegionMake(myLocation, span)

        map.setRegion(region, animated: true)
        self.map.showsUserLocation = true
        
        latitude = location.coordinate.latitude
        longitude = location.coordinate.longitude
        getWeather()
        
    }
    
    func getLocation() {
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyBest
        manager.requestWhenInUseAuthorization()
        manager.startUpdatingLocation()
    }
    
    func getWeather() {
        forecastService = ForecastService(APIKey: forecastAPIKey)
        forecastService.getCurrentWeather(latitude: latitude, longitude: longitude) { (currentWeather) in
            
            if let currentWeather = currentWeather {
                DispatchQueue.main.async {
                    
                    if let temperature = currentWeather.temperature {
                        self.temperatureLabel.text = "It's \(temperature) Fº"
                    
                    } else {
                        self.temperatureLabel.text = "-"
                    }
                }
            }
        }
    }

}
