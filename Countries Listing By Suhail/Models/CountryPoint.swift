//
//  CountryPoint.swift
//  Countries Listing By Suhail
//
//  Created by suhail on 06/01/24.
//


import Foundation
import MapKit

class CountryPoint: NSObject, MKAnnotation{
    var title: String?
    var coordinate: CLLocationCoordinate2D
    
    init(title: String? = nil, coordinate: CLLocationCoordinate2D) {
        self.title = title
        self.coordinate = coordinate
    }
}
