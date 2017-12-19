//
//  ViewController.swift
//  WeatherApp
//
//  Created by Angela Yu on 23/08/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import SwiftyJSON



class WeatherViewController: UIViewController, CLLocationManagerDelegate, UpdateCityLocationDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    //api.openweathermap.org/data/2.5/weather?lat=35&lon=139
    let APP_ID = "e72ca729af228beabd5d20e3b7749713"
    
     let weatherDataModel = WeatherDataModel()

    //TODO: Declare instance variables here
    let locationManager = CLLocationManager()


    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //TODO:Set up the location manager here.
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        
        
    }
    
    
    
    //MARK: - Networking
    /***************************************************************/
    
    //Write the getWeatherData method here:
    
    func getWeatherData(parameters: Parameters, appurl: String){
        
        Alamofire.request(appurl, method: .get, parameters: parameters).responseJSON {
            response in
            
            if let responseJson: JSON = JSON(response.result.value) {
            
            if response.result.isSuccess {
               
                print(responseJson)
                self.updateWeatherData(response: responseJson)
                
            }
            else if response.result.isFailure{
                
                
            }
                
            }
            
            
        }
        
        
    }
    
    
    
    
    
    //MARK: - JSON Parsing
    /***************************************************************/
   
    
    //Write the updateWeatherData method here:
    func updateWeatherData(response: JSON) {
        
      
       weatherDataModel.cityName = response["name"].string!
        cityLabel.text = weatherDataModel.cityName
        weatherDataModel.weather = Int((response["main"]["temp"].double!) - 273.15)
        //weatherDataModel.weatherIcon = response["weather"]["icon"].string!
        
        updateUiWithWeatherData()
    }

    
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    
    //Write the updateUIWithWeatherData method here:
    
    func updateUiWithWeatherData() {
        
        cityLabel.text = weatherDataModel.cityName
        temperatureLabel.text = String(weatherDataModel.weather)
    }
    
    
    
    
    
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    //Write the didUpdateLocations method here:
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations[locations.count - 1]
        let latitude = String(currentLocation.coordinate.latitude)
        let longitude = String(currentLocation.coordinate.longitude)
        let param: [String : String] = ["lat" : latitude, "lon" : longitude , "APPID" : APP_ID]
        print(param)
       getWeatherData(parameters: param, appurl: WEATHER_URL)
    }
    
    
    //Write the didFailWithError method here:
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        cityLabel.text = "Could not get your location"
    }
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/
    
    
    //Write the userEnteredANewCityName Delegate method here:
    func getCityNameFromDelegate(cityName: String) {
        
        cityLabel.text = cityName
      
    }

    
    //Write the PrepareForSegue Method here
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "changeCityName"){
            let viewController = segue.destination as? ChangeCityViewController
            viewController?.delegate = self
        }
    }
    
    
}


