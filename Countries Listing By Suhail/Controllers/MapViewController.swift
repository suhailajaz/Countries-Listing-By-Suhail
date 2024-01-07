//
//  ViewController.swift
//  Countries Listing By Suhail
//
//  Created by suhail on 06/01/24.
//

import UIKit
import MapKit
import CoreLocation

class MapViewController: UIViewController{
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var vwDropDown: UIView!
    @IBOutlet var lblCountry: UILabel!
    
    @IBOutlet var btnChangeMapType: UIControl!
    let countries = [Country]()
    var currentCountry : CountryPoint?
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        locationManager.delegate = self
        
        giveBordersAndCornerRadius()
        fetchCurrentLocation()
        
    }
    
}

// MARK: - IBActions
extension MapViewController{
    
    ///Displays the drop down menu with all the countries in case fetching is successful
    @IBAction func dropDownTapped(_ sender: UIControl) {
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "dropDown") as? DropDownViewController{
            
            vc.completion = { chosenCountry,allCountries in
                
                guard let mapCountry = chosenCountry,let wholeCountries = allCountries else {return}
                
                self.addMarker(markerRegion: mapCountry, fullCountries: wholeCountries)
                
            }
            
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            
            DispatchQueue.main.async(){ [weak self] in
                self?.present(vc, animated: true)
            }
            
        }
    }
    
    
    @IBAction func currentLocationTapped(_ sender: UIControl) {
        fetchCurrentLocation()
    }
    
}

// MARK: - MapKit Methods
extension MapViewController: MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is CountryPoint else { return nil }
        
        let identifier = "Country"
        
        var  annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            
        }else{
            annotationView?.annotation = annotation
        }
        
        guard let pinView = annotationView as? MKPinAnnotationView else { return nil }
        pinView.pinTintColor = UIColor.black
        
        return pinView
    }
}



// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate{
    
    func locationManager(_ manager: CLLocationManager,
                         didUpdateLocations locations: [CLLocation]){
        
        if  let location = locations.last{
            locationManager.stopUpdatingLocation()
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            addDefaultMarker(place: "Current Location", lat: lat, lon: lon)
            
        }
        
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error fetching location")
        
        addDefaultMarker(place: "Default Location", lat: 34.1289, lon: 74.8425)
    }
    
}
