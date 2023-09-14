//
//  LocationViewController.swift
//  CarruescoHudsonFinalProject (iOS)
//
//  Created by Hudson Carruesco on 12/9/21.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

class LocationViewController: UIViewController, UISearchBarDelegate, CLLocationManagerDelegate {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var cityNameDisplay: UILabel!
    
    var locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    // gets core location set up
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.distanceFilter = 1000.0
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        currentLocation = locationManager.location
        getInitialLocation()
    }
            
    // starts updating current location when the view appears
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        locationManager.startUpdatingLocation()
        currentLocation = locationManager.location
    }
    
    // stops updating current location when view disappears
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        locationManager.stopUpdatingLocation()
    }
    
    // gets initial current locationn nwhen the view loads
    func getInitialLocation() {
            if let currentLocation = currentLocation {
                LocationModel.shared.reverseGeocodeCurrentLocation(currentLocation)
                addPlacemarkToMap()
                cityNameDisplay.text = "\(LocationModel.shared.getCityName()), \(LocationModel.shared.getCountryCode())"
            }
    }
    
    // fires when the user is fiished searching for city name
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        if let input = searchBar.text {
        LocationModel.shared.geocodeSearchedCity(input)
            addPlacemarkToMap()
            cityNameDisplay.text = "\(LocationModel.shared.getCityName()), \(LocationModel.shared.getCountryCode())"
        }
        searchBar.resignFirstResponder()
    }
    
    // clears search bar and dismisses keyboard when cancel is pressed
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
    }
    
    // retrieves current location when current location button is pressed
    @IBAction func currentLocationButtonPressed(_ sender: UIButton) {
        searchBar.text = ""
        searchBar.resignFirstResponder()
        
        if let currentLocation = currentLocation {
            LocationModel.shared.reverseGeocodeCurrentLocation(currentLocation)
            addPlacemarkToMap()
            cityNameDisplay.text = "\(LocationModel.shared.getCityName()), \(LocationModel.shared.getCountryCode())"
        }
    }
    
    // adds placemark to map on the view
    func addPlacemarkToMap() {
        mapView.removeAnnotations(mapView.annotations)
        let coordinates =  CLLocationCoordinate2DMake(LocationModel.shared.getLat(), LocationModel.shared.getLong())
        let placemark = MKPointAnnotation()
        placemark.coordinate = coordinates
        placemark.title = LocationModel.shared.getCityName()
        let mapViewRegion = MKCoordinateRegion(center: placemark.coordinate, latitudinalMeters: 100000, longitudinalMeters: 100000)
        mapView.setRegion(mapViewRegion, animated: true)
        mapView.addAnnotation(placemark)
    }
}

