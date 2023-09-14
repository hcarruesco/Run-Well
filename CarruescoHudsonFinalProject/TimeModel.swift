//
//  TimeModel.swift
//  CarruescoHudsonFinalProject
//
//  Created by Hudson Carruesco on 12/11/21.
//

import Foundation
import UIKit

class TimeModel {
    
    public static let shared = TimeModel()

    private var isFutureTime: Bool
    private var hoursInFuture: Int
    private var selectedTime: Date
    
    init() {
        self.isFutureTime = false
        self.hoursInFuture = 0
        self.selectedTime = Date()
    }
    
    // updates time with data from the view
    func updateTime(selectedTime: Date, isFutureTime: Bool) {
        self.selectedTime = selectedTime
        self.isFutureTime = isFutureTime
        WeatherModel.shared.updateisForecast(isForecast: isFutureTime)
        calculateHoursInFuture()
    }
    
    // returns a string of the date and time
    func returnDateTimeString() -> String {
        return selectedTime.formatted(date: .numeric, time: .shortened)
    }
    
    // calculates how many hours in the future the user chose to forcast
    func calculateHoursInFuture() {
        let hoursAhead = Int(selectedTime.timeIntervalSinceNow / 3600)
        if isFutureTime {
            if hoursAhead < 1 {
                hoursInFuture = 1
            }
            else if hoursAhead > 48 {
                    hoursInFuture = 48
            }
            else {
                hoursInFuture = hoursAhead
            }
        }
        else {
            hoursInFuture = 0
        }
    }
    
    func getIsFutureTime() -> Bool {
        return isFutureTime
    }
    
    func getHoursInFuture() -> Int {
        return hoursInFuture
    }
}
