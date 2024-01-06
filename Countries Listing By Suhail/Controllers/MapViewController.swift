//
//  ViewController.swift
//  Countries Listing By Suhail
//
//  Created by suhail on 06/01/24.
//

import UIKit
import MapKit

class MapViewController: UIViewController{

    @IBOutlet var mapView: MKMapView!
    @IBOutlet var vwDropDown: UIView!
    @IBOutlet var lblCountry: UILabel!
    
    let countries = [Country]()
    var currentCountry : CountryPoint?
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        giveBordersAndCornerRadius()
        
         currentCountry = CountryPoint(title: "argentina", coordinate: CLLocationCoordinate2D(latitude: 23.4241, longitude: 53.8478))
        if let currentCountry = currentCountry{
            mapView.addAnnotation(currentCountry )
        }
      
    
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
                let lat = mapCountry.latlng[0]
                let lon = mapCountry.latlng[1]
                let newPoint = CountryPoint(title: mapCountry.name.common, coordinate: CLLocationCoordinate2D(latitude: lat, longitude: lon))
                DispatchQueue.main.async{[weak self] in
                    self?.currentCountry = newPoint
                    self?.mapView.addAnnotation(newPoint)
                    self?.lblCountry.text = mapCountry.name.common
                    let center = CLLocationCoordinate2D(latitude: lat, longitude: lon)
                    let region = MKCoordinateRegion(center: center, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    
                    self?.mapView.setRegion(region, animated: true)
                }
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

}

extension MapViewController: MKMapViewDelegate{
    func mapViewWillStartLoadingMap(_ mapView: MKMapView) {

        let center = CLLocationCoordinate2D(latitude: currentCountry?.coordinate.latitude ?? 0.0, longitude: currentCountry?.coordinate.longitude ?? 0.0)

            let regionRadius: CLLocationDistance = 900_000
       
            let region = MKCoordinateRegion(center: center, latitudinalMeters: regionRadius * 2.0, longitudinalMeters: regionRadius * 2.0)

            mapView.setRegion(region, animated: true)
        }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is CountryPoint else { return nil }
        
        let identifier = "Capital"
        
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
    
    func giveBordersAndCornerRadius(){
        vwDropDown.layer.borderColor = UIColor.darkGray.cgColor
        vwDropDown.layer.borderWidth = 1
        vwDropDown.layer.cornerRadius = 12
    }
}
