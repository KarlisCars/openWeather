//
//  ViewController.swift
//  openWeather
//
//  Created by Karlis Cars on 28/11/2019.
//  Copyright © 2019 Karlis Cars. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON

class WeatherViewController: UIViewController, CLLocationManagerDelegate, ChangeCityDelegate {
    
    
    
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var temperatureLabel: UILabel!
    
    let weatherUrl = "https://api.openweathermap.org/data/2.5/weather"
    let apiID = "11dae37b2c358760f28b8cd0c94a8d14"
    
    let locationManager = CLLocationManager()
    let weatherDataModel = WeatherDataModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
    
    // MARK: - Location Manager Delegate Methods
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count - 1]
        
        if location.horizontalAccuracy > 0 {
            self.locationManager.stopUpdatingLocation()
            print("longitude = \(location.coordinate.longitude), latitude = \(location.coordinate.latitude)")
            
            let latitude = String(location.coordinate.latitude)
            let longitude = String(location.coordinate.longitude)
            
            let params : [String: String] = ["lat" : latitude, "lon": longitude, "appid": apiID]
            
            getWeatherData(url: weatherUrl, parameters: params)
            
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Weather Unavailable 😅"
    }
    
    // MARK: Networking
    
    func getWeatherData(url: String, parameters: [String: String]){
        
        
        AF.request(url, method: .get, parameters: parameters).responseJSON { (response) in
            if response.value != nil {
                print("Got weather data")
                let weatherJSON: JSON = JSON(response.value!)
                // print(weatherJSON)
                self.updateWeatherData(json: weatherJSON)
                
            }else{
                print("Error \(String(describing: response.error))")
                self.cityLabel.text = "Weather Unavailable 😅"
            }
        }
    }
    
    // MARK: - Parsing JSON with SwiftyJSON
    func updateWeatherData(json: JSON){
        
        if let tempResult = json["main"]["temp"].double{
            weatherDataModel.temperature = Int(tempResult - 273.15)
            weatherDataModel.city = json["name"].stringValue
            weatherDataModel.condition = json["weather"][0]["id"].intValue
            
            weatherDataModel.weatherIconName = weatherDataModel.updateWeatherIcon(condition: weatherDataModel.condition)
            
            updateUIWithWeatherData()
            
        }else{
            self.cityLabel.text = "Weather Unavailable 😅"
        }
    }
    // MARK: UpdateUi
    
    func updateUIWithWeatherData(){
        cityLabel.text = weatherDataModel.city
        temperatureLabel.text = "\(weatherDataModel.temperature) º"
        weatherIcon.image = UIImage(named: weatherDataModel.weatherIconName)
    }
    
    
    // MARK: - ChangeCityDelegate
    
    func userEnteredaNewCityName(city: String) {
        print(city)
        let params : [String: String] = ["q" : city, "appId": apiID]
        getWeatherData(url: weatherUrl, parameters: params)
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "cityId" {
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
            
        }
    }
    
}



