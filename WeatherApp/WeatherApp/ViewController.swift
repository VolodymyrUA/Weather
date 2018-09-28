//
//  ViewController.swift
//  WeatherApp
//
//  Created by Володимир Смульський on 9/27/18.
//  Copyright © 2018 Володимир Смульський. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import CoreLocation

class ViewController: UIViewController {
    
    var weather : Weather?
    let basePath = "https://api.sunrise-sunset.org/json?"
    
    @IBAction func searchButtonClicked(_ sender: UIButton) {
        if let locationString = cityNameNextField.text, !locationString.isEmpty {
            updateWeatherLocation(location: locationString)
        }
    }
    
    @IBOutlet weak var sunriseLabel: UILabel!
    @IBOutlet weak var sunsetLabel: UILabel!
    @IBOutlet weak var cityNameNextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateWeatherLocation(location: "Lviv")
    }
    
    func getСityCoordinates(withLocation location: CLLocationCoordinate2D) {
        
        let url = basePath + "lat=\(location.latitude)&lng=\(location.longitude)"
        let urlRequest = URLRequest(url: URL(string: url)!)
        
        Alamofire.request( urlRequest).validate(statusCode: 200..<300).response { response  in
            guard response.error == nil else {
                NSLog("Error:\(String(describing: response.error))")
                return
            }
            
            guard let data = response.data else {
                NSLog("No data \(String(describing: response.error))")
                return
            }
            do {
                let json = try JSON.init(data: data)
                
                let sunrise = json["results","sunrise"].string
                let sunset  = json["results","sunset"].string
                
                self.weather = Weather(sunrise: sunrise!, sunset: sunset!)
                self.setLabels()
                
            } catch {
                NSLog("Error: \(error)")
            }
        }
    }
    
    func updateWeatherLocation (location: String) {
        CLGeocoder().geocodeAddressString(location) { (placemarks:[CLPlacemark]?, error:Error?) in
            if error == nil {
                if let location = placemarks?.first?.location {
                    self.getСityCoordinates( withLocation: location.coordinate)
                }
            }
        }
    }
    
    func setLabels() {
        if let sunrise = weather?.sunrise { sunriseLabel.text = sunrise }
        if let sunset  = weather?.sunset  { sunsetLabel.text  = sunset  }
    }
}
