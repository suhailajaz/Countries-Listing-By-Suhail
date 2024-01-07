//
//  CountriesCD+CoreDataProperties.swift
//  Countries Listing By Suhail
//
//  Created by suhail on 07/01/24.
//
//

import Foundation
import CoreData


extension CountriesCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CountriesCD> {
        return NSFetchRequest<CountriesCD>(entityName: "CountriesCD")
    }

    @NSManaged public var id: UUID?
    @NSManaged public var name: String?
    @NSManaged public var lat: Double
    @NSManaged public var lon: Double
    @NSManaged public var flagLink: String?

}

extension CountriesCD : Identifiable {

}
