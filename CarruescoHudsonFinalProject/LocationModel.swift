//
//  LocationModel.swift
//  CarruescoHudsonFinalProject
//
//  Created by Hudson Carruesco on 12/9/21.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class LocationModel: CLGeocoder, CLLocationManagerDelegate {
    
    public static let shared = LocationModel()
    
    private var geocoder = CLGeocoder()
    private var longitude: Double
    private var latitude: Double
    private var cityName: String
    private var countryCode: String
    
    override init() {
        self.longitude = 0
        self.latitude = 0
        self.cityName = ""
        self.countryCode = ""
        super.init()
    }
    
    // takes searched for city name and geocodes it into a placemark to get data form
    func geocodeSearchedCity(_ cityName: String) {
        // Use the last reported location.
        let geocoder = CLGeocoder()
            
        // Look up the location and pass it to the completion handler
        geocoder.geocodeAddressString(cityName,
                    completionHandler: { (placemarks, error) in
            if error == nil {
                if let newPlacemark = placemarks?.first {
                    self.longitude = newPlacemark.location!.coordinate.longitude
                    self.latitude = newPlacemark.location!.coordinate.latitude
                    self.cityName = newPlacemark.locality!
                    self.countryCode = newPlacemark.isoCountryCode!
                }
                else {
                    print("No placemark returned")
                }
            }
            else {
             // An error occurred during geocoding.
                print("An error occurred during geocoding")
            }
        })
    }
    
    // takes current location and reverse geocodes it to get data from it
    func reverseGeocodeCurrentLocation(_ currentLocation: CLLocation?) {
        // Use the last reported location.
        if let newCurrentLocation = currentLocation {
            let geocoder = CLGeocoder()
                
            // Look up the location and pass it to the completion handler
            geocoder.reverseGeocodeLocation(newCurrentLocation,
                        completionHandler: { (placemarks, error) in
                if error == nil {
                    if let newPlacemark = placemarks?.first {
                        self.longitude = newPlacemark.location!.coordinate.longitude
                        self.latitude = newPlacemark.location!.coordinate.latitude
                        self.cityName = newPlacemark.locality!
                        self.countryCode = newPlacemark.isoCountryCode!
                    }
                    else {
                        print("No placemark returned")
                    }
                }
                else {
                 // An error occurred during geocoding.
                    print("An error occurred during geocoding")
                }
            })
        }
        else {
            // No location was available.
            print("No location was available")

        }
    }
    
    func getLong() -> Double {
        return longitude
    }
    
    func getLat() -> Double {
        return latitude
    }
    
    func getCityName() -> String {
        return cityName
    }

    func getCountryCode() -> String {
        return countryCode
    }
}
