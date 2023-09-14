//
//  RunningScoreViewController.swift
//  CarruescoHudsonFinalProject
//
//  Created by Hudson Carruesco on 12/8/21.
//

import Foundation
import UIKit

class RunningScoreViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var totalRunningScoreLabel: UILabel!
    @IBOutlet weak var dateAndTimeLabel: UILabel!
    @IBOutlet weak var tempScoreLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var precipLabel: UILabel!
    @IBOutlet weak var precipScoreLabel: UILabel!
    @IBOutlet weak var AQILabel: UILabel!
    @IBOutlet weak var AQIScoreLabel: UILabel!
    @IBOutlet weak var UVIndexLabel: UILabel!
    @IBOutlet weak var UVScoreLabel: UILabel!
    
    override func viewDidLoad() {
        
        totalRunningScoreLabel.layer.cornerRadius = totalRunningScoreLabel.frame.width/1.66
        totalRunningScoreLabel.layer.masksToBounds = true
        totalRunningScoreLabel.layer.borderColor = UIColor.black.cgColor
        totalRunningScoreLabel.layer.borderWidth = 6.0
        tempScoreLabel.layer.cornerRadius = tempScoreLabel.frame.width/2
        tempScoreLabel.layer.masksToBounds = true
        tempScoreLabel.layer.borderColor = UIColor.black.cgColor
        tempScoreLabel.layer.borderWidth = 3.0
        precipScoreLabel.layer.cornerRadius = precipScoreLabel.frame.width/2
        precipScoreLabel.layer.masksToBounds = true
        precipScoreLabel.layer.borderColor = UIColor.black.cgColor
        precipScoreLabel.layer.borderWidth = 3.0
        AQIScoreLabel.layer.cornerRadius = AQIScoreLabel.frame.width/2
        AQIScoreLabel.layer.masksToBounds = true
        AQIScoreLabel.layer.borderColor = UIColor.black.cgColor
        AQIScoreLabel.layer.borderWidth = 3.0
        UVScoreLabel.layer.cornerRadius = UVScoreLabel.frame.width/2
        UVScoreLabel.layer.masksToBounds = true
        UVScoreLabel.layer.borderColor = UIColor.black.cgColor
        UVScoreLabel.layer.borderWidth = 3.0
        
    }
    
    // gets and displays new weather data each time the view appears
    override func viewWillAppear(_ animated: Bool) {
        retrieveNewWeatherData()
        WeatherModel.shared.calculateScores()
        updateWeatherDisplay()
    }
    
    // gets new weather data based o ntime and location
    func retrieveNewWeatherData() {
        WeatherModel.shared.updateURLS()
        
        if TimeModel.shared.getIsFutureTime() {
            WeatherModel.shared.getOnlineWeatherData(url: WeatherModel.shared.getURLForecastWeather(), isForecast: true, isAQI: false)
            WeatherModel.shared.getOnlineWeatherData(url: WeatherModel.shared.getURLForecastAQI(), isForecast: true, isAQI: true)
        }
        else {
            WeatherModel.shared.getOnlineWeatherData(url: WeatherModel.shared.getURLCurrentWeather(), isForecast: false, isAQI: false)
            WeatherModel.shared.getOnlineWeatherData(url: WeatherModel.shared.getURLCurrentAQI(), isForecast: false, isAQI: true)
        }
    }
        
    // updates view with new data
    func updateWeatherDisplay() {
        
        cityNameLabel.text = "\(LocationModel.shared.getCityName()), \(LocationModel.shared.getCountryCode())"
        dateAndTimeLabel.text = TimeModel.shared.returnDateTimeString()
        tempLabel.text = "Temperature: \(Int(WeatherModel.shared.getTemp()))°F"
        if WeatherModel.shared.getIsForecast() {
            precipLabel.text = "Precipitation: \(WeatherModel.shared.getPrecip())%"
        }
        else {
            precipLabel.text = "Precipitation: \(WeatherModel.shared.getPrecip()) in."
        }
        AQILabel.text = "AQI: \(Int(WeatherModel.shared.getAQI()))"
        UVIndexLabel.text = "UV Index: \(WeatherModel.shared.getUVI())"
        totalRunningScoreLabel.text = String(WeatherModel.shared.getTotalRunningScore())
        tempScoreLabel.text = String(WeatherModel.shared.getTempScore())
        precipScoreLabel.text = String(WeatherModel.shared.getPrecipScore())
        AQIScoreLabel.text = String(WeatherModel.shared.getAQIScore())
        UVScoreLabel.text = String(WeatherModel.shared.getUVIScore())
        setScoreColor(WeatherModel.shared.getTotalRunningScore(), scoreLabel: totalRunningScoreLabel)
        setScoreColor(WeatherModel.shared.getTempScore(), scoreLabel: tempScoreLabel)
        setScoreColor(WeatherModel.shared.getPrecipScore(), scoreLabel: precipScoreLabel)
        setScoreColor(WeatherModel.shared.getAQIScore(), scoreLabel: AQIScoreLabel)
        setScoreColor(WeatherModel.shared.getUVIScore(), scoreLabel: UVScoreLabel)
    }
    
    // takes each section's score and assigns a color from green to red based on how good/bad it is
    func setScoreColor(_ score: Double, scoreLabel: UILabel) {
        if (score < 2) {
            scoreLabel.backgroundColor = UIColor(red: 0.949, green: 0.0157, blue: 0, alpha: 1.0)
        }
        else if (score < 3) {
            scoreLabel.backgroundColor = UIColor(red: 0.949, green: 0.2294, blue: 0, alpha: 1.0)
        }
        else if (score < 4) {
            scoreLabel.backgroundColor = UIColor(red: 0.949, green: 0.4431, blue: 0, alpha: 1.0)
        }
        else if (score < 5) {
            scoreLabel.backgroundColor = UIColor(red: 0.949, green: 0.6627, blue: 0, alpha: 1.0)
        }
        else if (score < 6) {
            scoreLabel.backgroundColor = UIColor(red: 0.949, green: 0.8353, blue: 0, alpha: 1.0)
        }
        else if (score < 7) {
            scoreLabel.backgroundColor = UIColor(red: 0.7569, green: 0.949, blue: 0, alpha: 1.0)
        }
        else if (score < 8) {
            scoreLabel.backgroundColor = UIColor(red: 0.6157, green: 0.949, blue: 0, alpha: 1.0)
        }
        else if (score < 9) {
            scoreLabel.backgroundColor = UIColor(red: 0.4275, green: 0.949, blue: 0, alpha: 1.0)
        }
        else if (score < 10) {
            scoreLabel.backgroundColor = UIColor(red: 0.251, green: 0.949, blue: 0, alpha: 1.0)
        }
        else if (score == 10) {
            scoreLabel.backgroundColor = UIColor(red: 0.0667, green: 0.8275, blue: 0, alpha: 1.0)
        }
    }
}
