//
//  MapViewControllerExtension.swift
//  Countries Listing By Suhail
//
//  Created by suhail on 07/01/24.
//

import Foundation
import UIKit
import CoreLocation
import MapKit

// MARK: - Custom functions{
extension MapViewController{
    
    ///used to add a marker to the map
    func addMarker(markerPlace: CountriesCD){
        
        let lat = markerPlace.lat
        let lon = markerPlace.lon
        let newPoint = CountryPoint(title: markerPlace.name, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        
        DispatchQueue.main.async{[weak self] in
            self?.removePreviousAnnotations()
            self?.mapView.addAnnotation(newPoint)
            self?.lblCountry.text = markerPlace.name
            self?.updateRegion(lat: lat, lon: lon)
        }
    }
    
    ///adds adefault marker to user's current location on startup
    func addDefaultMarker(place: String,lat: Double, lon: Double){
        
        let newPoint = CountryPoint(title: place, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        
        DispatchQueue.main.async{[weak self] in
            self?.removePreviousAnnotations()
            self?.mapView.addAnnotation(newPoint)
            self?.lblCountry.text = place
            self?.updateRegion(lat: lat, lon: lon)
        }
    }
    
    ///used to update to the new location once selected from the drop down menu
    func updateRegion(lat: Double, lon:Double){
        DispatchQueue.main.async{[weak self] in
            
            let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 2.00, longitudeDelta: 2.00))
            
            self?.mapView.setRegion(region, animated: true)
        }
    }
    ///cosmetic method used for giving borders and corner radius to views
    func giveBordersAndCornerRadius(){
        vwDropDown.layer.borderColor = UIColor.darkGray.cgColor
        vwDropDown.layer.borderWidth = 1
        vwDropDown.layer.cornerRadius = 12
        
        btnChangeMapType.layer.borderColor = UIColor.darkGray.cgColor
        btnChangeMapType.layer.backgroundColor = UIColor.link.cgColor
        btnChangeMapType.layer.borderWidth = 1
        btnChangeMapType.layer.cornerRadius = 12
        
    }
    
    func removePreviousAnnotations(){
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
    }
    
    func fetchCurrentLocation(){
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestLocation()
    }
    
    ///used to change the map type
    @IBAction func changeMapTapped(_ sender: UIControl) {
        
        let ac = UIAlertController(title: "Select map type", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "Satellite", style: .default,handler: { [weak self] _ in
            self?.title = "Satellite"
            self?.mapView.mapType = .satellite
        }))
        ac.addAction(UIAlertAction(title: "Hybrid", style: .default,handler: { [weak self] _ in
            self?.title = "Hybrid"
            self?.mapView.mapType = .hybrid
        }))
        ac.addAction(UIAlertAction(title: "Satellite Flyover", style: .default,handler: { [weak self] _ in
            self?.title = "Satellite Flyover"
            self?.mapView.mapType = .satelliteFlyover
        }))
        ac.addAction(UIAlertAction(title: "Standard", style: .default,handler: { [weak self] _ in
            self?.title = "Standard"
            self?.mapView.mapType = .standard
        }))
        ac.addAction(UIAlertAction(title: "Cancel", style: .default))
        
        ac.popoverPresentationController?.barButtonItem = navigationItem.rightBarButtonItem
        present(ac,animated: true)
    }
    
}
