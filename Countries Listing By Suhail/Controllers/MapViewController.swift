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
        //addMarker(markerPlace: Country(name: Name(common: "france"), latlng: [46.2276,2.2137]))
      
    
    }

  
   
}
// MARK: - IBActions
extension MapViewController{
    @IBAction func dropDownTapped(_ sender: UIControl) {
        print("DropDown Tapped")
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "dropDown") as? DropDownViewController{
            
            vc.completion = { chosenCountry in
                print("%%%%%")
                print("\(chosenCountry ) returned from drop down")
               
                guard let mapCountry = chosenCountry else {return}
                self.addMarker(markerPlace: mapCountry)
                
               // let currentCountry = CountryPoint(title: mapCountry.name.common, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
               // mapView.addAnnotation(currentCountry)
           
                
            }
            vc.modalPresentationStyle = .overCurrentContext
            vc.modalTransitionStyle = .crossDissolve
            DispatchQueue.main.async(){ [weak self] in
                self?.present(vc, animated: true)
            }
       
        }
    }
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
    @IBAction func currentLocationTapped(_ sender: UIControl) {
        fetchCurrentLocation()
    }
    
}

extension MapViewController: MKMapViewDelegate{
//    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {
//
//        let center = CLLocationCoordinate2D(latitude: currentCountry?.coordinate.latitude ?? 0.0, longitude: currentCountry?.coordinate.longitude ?? 0.0)
//
//            let regionRadius: CLLocationDistance = 900_000
//       
//            let region = MKCoordinateRegion(center: center, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)
//
//            mapView.setRegion(region, animated: true)
//        }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is CountryPoint else { return nil }
        
        let identifier = "Country"
        
        var  annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            //annotationView?.canShowCallout = true
            
           // let btn = UIButton(type: .detailDisclosure)
           // annotationView?.rightCalloutAccessoryView = btn
        }else{
            annotationView?.annotation = annotation
        }
        
        guard let pinView = annotationView as? MKPinAnnotationView else { return nil }
        pinView.pinTintColor = UIColor.black
        
        return pinView
    }
}

// MARK: - Custom functions{
extension MapViewController{
    func addMarker(markerPlace: Country){
//        currentCountry = CountryPoint(title: "argentina", coordinate: CLLocationCoordinate2D(latitude: 23.4241, longitude: 53.8478))
//       if let currentCountry = currentCountry{
//           mapView.addAnnotation(currentCountry)
//       }
        
        
        let lat = markerPlace.latlng[0]
        let lon = markerPlace.latlng[1]
        let newPoint = CountryPoint(title: markerPlace.name.common, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
        
        DispatchQueue.main.async{[weak self] in
            //self?.currentCountry = newPoint
            self?.removePreviousAnnotations()
            self?.mapView.addAnnotation(newPoint)
            self?.lblCountry.text = markerPlace.name.common
            self?.updateRegion(lat: lat, lon: lon)
        }
    }
    
    func updateRegion(lat: Double, lon:Double){
        DispatchQueue.main.async{[weak self] in
           
            let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 2.00, longitudeDelta: 2.00))
            
            self?.mapView.setRegion(region, animated: true)
        }
    }
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
}


// MARK: - CLLocationManagerDelegate
extension MapViewController: CLLocationManagerDelegate{
    
     func locationManager(_ manager: CLLocationManager,
                          didUpdateLocations locations: [CLLocation]){
         
         if  let location = locations.last{
             locationManager.stopUpdatingLocation()
             let lat = location.coordinate.latitude
             let lon = location.coordinate.longitude
            // weatherManager.fetchWeather(latitude: lat, longitude: lon)
             addMarker(markerPlace: Country(name: Name(common: "Current Location"), latlng: [lat,lon]))
             
         }
    
     
     }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("error fetching location")
        addMarker(markerPlace: Country(name: Name(common: "Failsafe Location"), latlng: [34.1289,74.8425]))
    }

}
