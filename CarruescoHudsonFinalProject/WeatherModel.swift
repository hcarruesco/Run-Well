//
//  WeatherModel.swift
//  CarruescoHudsonFinalProject
//
//  Created by Hudson Carruesco on 12/10/21.
//

import Foundation
import UIKit

class WeatherModel {
    
    public static let shared = WeatherModel()
    
    private var isForecast: Bool
    private var temp: Double
    private var precip: Double
    private var AQI: Double
    private var UVI: Double
    private var totalRunningScore: Double
    private var tempScore: Double
    private var precipScore: Double
    private var AQIScore: Double
    private var UVIScore: Double
    private var urlCurrentWeather: String
    private var urlForecastWeather: String
    private var urlCurrentAQI: String
    private var urlForecastAQI: String
    
    init() {
        self.isForecast = false
        self.temp = 0
        self.precip = 0
        self.AQI = 0
        self.UVI = 0
        self.totalRunningScore = 0
        self.tempScore = 0
        self.precipScore = 0
        self.AQIScore = 0
        self.UVIScore = 0
        self.urlCurrentWeather = "https://api.openweathermap.org/data/2.5/onecall?lat=\(LocationModel.shared.getLat())&lon=\(LocationModel.shared.getLong())&exclude=minutely,hourly,daily,alerts&units=imperial&appid=INSERT_TOKEN_HERE"
        self.urlForecastWeather = "https://api.openweathermap.org/data/2.5/onecall?lat=\(LocationModel.shared.getLat())&lon=\(LocationModel.shared.getLong())&exclude=current,minutely,daily,alerts&units=imperial&appid=INSERT_TOKEN_HERE"
        self.urlCurrentAQI = "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(LocationModel.shared.getLat())&lon=\(LocationModel.shared.getLong())&appid=INSERT_TOKEN_HERE"
        self.urlForecastAQI = "https://api.openweathermap.org/data/2.5/air_pollution/forecast?lat=\(LocationModel.shared.getLat())&lon=\(LocationModel.shared.getLong())&appid=INSERT_TOKEN_HERE"
        getOnlineWeatherData(url: urlCurrentWeather, isForecast: false, isAQI: false)
        getOnlineWeatherData(url: urlCurrentAQI, isForecast: false, isAQI: true)
    }
    
    // pulls weather data from online given a url and whether the data is current or forecast and AQI or weather
    func getOnlineWeatherData(url: String, isForecast: Bool, isAQI: Bool) {
        // code adapted from https://betterprogramming.pub/json-parsing-in-swift-2498099b78fepkw
        guard let URL = URL(string: url) else {return}
        let task = URLSession.shared.dataTask(with: URL) { (data, response, error) in

            guard let dataResponse = data, error == nil else {
                print(error!.localizedDescription)
                return
            }
            do{
                if !isForecast && !isAQI {
                    self.decodeCurrentWeatherJSON(currentWeatherJSONData: dataResponse)
                }
                else if isForecast && !isAQI {
                    self.decodeForecastWeatherJSON(forecastWeatherJSONData: dataResponse)
                }
                else if !isForecast && isAQI {
                    self.decodeCurrentAQIJSON(currentAQIJSONData: dataResponse)
                }
                else if isForecast && isAQI {
                    self.decodeForecastAQIJSON(forecastAQIJSONData: dataResponse)
                }
             }
        }
        task.resume()
    }
    
    // structs to help with JSON data reading
    struct CurrentWeather: Codable {
        var current: CurrentWeatherSpecifics?
    }
        
    struct CurrentWeatherSpecifics: Codable {
        var rain: CurrentRain?
        var temp: Double?
        var uvi: Double?
    }

    struct CurrentRain: Codable {
        var oneHour: Double?
    }
    
    enum CodingKeys: String, CodingKey {
        case oneHour = "1h"
    }
    
    struct MainForecastWeather: Codable {
        var hourly: [HourlyWeather]?
    }
    
    struct HourlyWeather: Codable {
        var pop: Double?
        var temp: Double?
        var uvi: Double?
    }
    
    struct ListAQI: Codable {
        var list: [MainAQI]?
    }
    
    struct MainAQI: Codable {
        var main: AQILevel?
    }
    
    struct AQILevel: Codable {
        var aqi: Double?
    }
    
    // decodes JSON data for current weather
    func decodeCurrentWeatherJSON(currentWeatherJSONData: Data) {
        let response = try! JSONDecoder().decode(CurrentWeather.self, from: currentWeatherJSONData)
        
        if let weatherData = response.current {
            if let temperature = weatherData.temp, let uvIndex = weatherData.uvi {
                temp = temperature
                UVI = uvIndex
                if let possibleRain = weatherData.rain {
                    if let rainfall = possibleRain.oneHour {
                        precip = rainfall
                    }
                }
                else {
                    precip = 0
                }
            }
            else {
                print("Error retrieving current weather data")
            }
        }
    }
    
    // decodes JSON data for forecasted weather
    func decodeForecastWeatherJSON(forecastWeatherJSONData: Data) {
        let response = try! JSONDecoder().decode(MainForecastWeather.self, from: forecastWeatherJSONData)
        
        if let forecastList = response.hourly {
            let forecastedHour = forecastList[TimeModel.shared.getHoursInFuture()-1]
            if let forecastedTemp = forecastedHour.temp, let forecastedPrecip = forecastedHour.pop, let forecastedUVI = forecastedHour.uvi {
                temp = forecastedTemp
                precip = forecastedPrecip*100
                UVI = forecastedUVI
            }
            else {
                print("Error retrieving hourly weather data")
            }
        }
        else {
            print("Error retrieving weather data for specificied hour")
        }
    }
    
    // decodes JSON data for current AQI
    func decodeCurrentAQIJSON(currentAQIJSONData: Data) {
        let response = try! JSONDecoder().decode(ListAQI.self, from: currentAQIJSONData)
        
        if let AQIList = response.list {
            if let mainAQIData = AQIList[0].main {
                if let currentAQI = mainAQIData.aqi {
                    AQI = currentAQI
                }
                else {
                    print("Error retrieving current AQI")
                }
            }
            else {
                print("Error retrieving main AQI data")
            }
        }
        else {
            print("Error retrieving AQI data list")
        }
        
    }

    // decodes JSON data for forecasted AQI
    func decodeForecastAQIJSON(forecastAQIJSONData: Data) {
        let response = try! JSONDecoder().decode(ListAQI.self, from: forecastAQIJSONData)
        
        if let AQIList = response.list {
            if let forecastedHour = AQIList[TimeModel.shared.getHoursInFuture()-1].main {
                if let forecastedAQI = forecastedHour.aqi {
                    AQI = forecastedAQI
                }
                else {
                    print("Error retrieving forecasted AQI")
                }
            }
            else {
                print("Error retrieving AQI data for specidfied hour")
            }
        }
        else {
            print("Error retrieving AQI data list")
        }
    }
    
    // calculates all the different running scores out of 10
    func calculateScores() {
        calculateTempScore()
        calculatePrecipScore()
        calculateAQIScore()
        calculateUVIScore()
        calculateTotalRunningScore()
    }
    
    
    func calculateTempScore() {
        // scores temperature out of 10 based on absolute value distance from baseline of 66 to max/min temps of 32 or 100
        let absValueFrom66 = abs(temp - 66)
        var outOf10 = 10 - ((absValueFrom66/34) * 10)
        if outOf10 > 10 {
            outOf10 = 10
        }
        else if outOf10 < 0 {
            outOf10 = 0
        }
        tempScore = round(outOf10*10)/10
    }
    
    func calculatePrecipScore() {
        
        // accounts for different values gotton from current and hourly weather data
        // current returns how much precipitation has fallen in the past hour
        // hourly returns the fiorecasted chance that precipitation may fall
        if isForecast {
            var outOf10 = 10 - (precip/10)
            if outOf10 > 10 {
                outOf10 = 10
            }
            precipScore = round(outOf10*10)/10
        }
        else {
            let outOf10 = 10 - (precip*10)
            precipScore = round(outOf10*10)/10
        }
    }
    
    func calculateAQIScore() {
        var outOf10: Double = 0
        if AQI == 1 {
            outOf10 = 10
        }
        else if AQI == 2 {
            outOf10 = 8
        }
        else if AQI == 3 {
            outOf10 = 6
        }
        else if AQI == 4 {
            outOf10 = 4
        }
        else if AQI == 5 {
            outOf10 = 2
        }
        else if AQI > 5 {
            outOf10 = 10
        }
        AQIScore = round(outOf10*10)/10
    }
    
    func calculateUVIScore() {
        var outOf10 = 10 - UVI
        if outOf10 > 10 {
            outOf10 = 10
        }
        UVIScore = round(outOf10*10)/10
    }
    
    func calculateTotalRunningScore() {
        let outOf10 = (tempScore + precipScore + AQIScore + UVIScore)/4
        totalRunningScore = round(outOf10*10)/10
    }
    
    // updates urls with new coordinates
    func updateURLS () {
        urlCurrentWeather = "https://api.openweathermap.org/data/2.5/onecall?lat=\(LocationModel.shared.getLat())&lon=\(LocationModel.shared.getLong())&exclude=minutely,hourly,daily,alerts&units=imperial&appid=INSERT_TOKEN_HERE"
        urlForecastWeather = "https://api.openweathermap.org/data/2.5/onecall?lat=\(LocationModel.shared.getLat())&lon=\(LocationModel.shared.getLong())&exclude=current,minutely,daily,alerts&units=imperial&appid=INSERT_TOKEN_HERE"
        urlCurrentAQI = "https://api.openweathermap.org/data/2.5/air_pollution?lat=\(LocationModel.shared.getLat())&lon=\(LocationModel.shared.getLong())&appid=INSERT_TOKEN_HERE"
        urlForecastAQI = "https://api.openweathermap.org/data/2.5/air_pollution/forecast?lat=\(LocationModel.shared.getLat())&lon=\(LocationModel.shared.getLong())&appid=INSERT_TOKEN_HERE"
    }
    
    func updateisForecast(isForecast: Bool) {
        self.isForecast = isForecast
    }
    
    func getTemp() -> Double {
        return temp
    }
    
    func getPrecip() -> Double {
        return precip
    }
    
    func getAQI() -> Double {
        return AQI
    }
    
    func getUVI() -> Double {
        return UVI
    }
    
    func getTotalRunningScore() -> Double {
        return totalRunningScore
    }
    
    func getTempScore() -> Double {
        return tempScore
    }
    
    func getPrecipScore() -> Double {
        return precipScore
    }
    
    func getAQIScore() -> Double {
        return AQIScore
    }
    
    func getUVIScore() -> Double {
        return UVIScore
    }
    
    func getURLCurrentWeather() -> String {
        return urlCurrentWeather
    }
    
    func getURLForecastWeather() -> String {
        return urlForecastWeather
    }
    
    func getURLCurrentAQI() -> String {
        return urlCurrentAQI
    }
    
    func getIsForecast() -> Bool {
        return isForecast
    }
    
    func getURLForecastAQI() -> String {
        return urlForecastAQI
    }
    
}
 

