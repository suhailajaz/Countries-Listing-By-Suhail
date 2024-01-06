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
    //let currencies: Currencies
   // let capital: [String]
//    let region: String
//  //  let languages: Languages
    let latlng: [Double]
//   let area: Double
//    let timezones:[String]
//    let population: Int
//    
//    let flag: String
//    let flags: Flags
}

struct Name: Codable{
    let common: String
  //  let official: String
}



struct Currencies: Codable {
    let eur: Eur
}

struct Eur: Codable {
    let name: String
    let symbol: String
}

struct Languages: Codable {
    let ara: String
}

struct Flags: Codable{
    let png: String
    let alt: String?
}
