//
//  Country.swift
//  Countries Listing By Suhail
//
//  Created by suhail on 06/01/24.
//

import Foundation
import Foundation

struct Country: Codable{
    
   let name:Name
   let latlng: [Double]
   let flags: Flags
}

struct Name: Codable{
    let common: String
 
}

struct Flags: Codable{
    let png: String
   
}
