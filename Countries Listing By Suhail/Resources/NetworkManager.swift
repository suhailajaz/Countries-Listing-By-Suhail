//
//  NetworkManager.swift
//  Countries Listing By Suhail
//
//  Created by suhail on 06/01/24.
//

import Foundation
import UIKit
import CoreData

protocol NetworkManagerDelegate{
    func updateUI(parsedCountries: [CountriesCD])
    func networkError(error: Error)
}

struct NetworkManager{
    
    var delegate: NetworkManagerDelegate?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    func fetchData(completion: @escaping (Bool)->()){
        let urlString = "https://restcountries.com/v3.1/all"

            if let url = URL(string: urlString){
                parseJSON(url: url) { success in
                    completion(true)
                }

            }else{
                print("error 2")
            }
        
        
    }
    
    func parseJSON(url: URL,completion: @escaping (Bool)->()){
        print("fetching data from API")
        URLSession.shared.dataTask(with: url) { data, response, error in
                  if let error = error {
                      print("Error 1: \(error.localizedDescription)")
                      delegate?.networkError(error: error)
                      return
                  }
                  
                  if let data = data {
                      do {
                          let decoder = JSONDecoder()
                          let countryData = try decoder.decode([Country].self, from: data)
                          
                          //self.countries = countryData
                          //filteredCountries = countries
                          print("######")
                          //print(countryData)
                          
                         cacheQuestionsToLocalDB(parsedCountries: countryData) { success in
                              print("Data sucessfully cached")
                             completion(true)
                          }
                          //delegate?.updateUI(parsedCountries: countryData)
                        

                      } catch {
                          print("JSON decoding error: \(error.localizedDescription)")
                          delegate?.networkError(error: error)
                      }
                  }
              }.resume()
    }
    
}

// MARK: - Caching to local db
extension NetworkManager{

    func cacheQuestionsToLocalDB(parsedCountries:[Country],completion: @escaping (Bool)->()){
       // deleteAllRecords(entity: "CountriesThree")
            for parsedCountry in parsedCountries{
                print("########")
                print(parsedCountry.name.common )
                print(parsedCountry.latlng[0])
                print(parsedCountry.latlng[1])
                print(parsedCountry.flags.png)
                print("########")
                let newCountry = CountriesCD(context: self.context)

                newCountry.name = parsedCountry.name.common
                newCountry.lat = parsedCountry.latlng[0]
                newCountry.lon = parsedCountry.latlng[1]
                newCountry.flagLink = parsedCountry.flags.png
                    
                        do{
                            try self.context.save()
                            completion(true)
                        }catch{
                            print(error.localizedDescription)
                        }
                
            }
            
                
            }
    
    func fetchCachedCountries()->[CountriesCD]?{
        do{
            var country = try context.fetch(CountriesCD.fetchRequest())
            country.sort { $0.name?.localizedCaseInsensitiveCompare($1.name ?? "No name") == .orderedAscending }
           return country
        }catch{
            print("Could not fetch questions!")
        }
        return nil
    }
        
//        func deleteAllRecords(entity : String) {
//
//                //let managedContext = CoreDataManager.sharedManager.persistentContainer.viewContext //your context
//                let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
//                let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
//                
//                do {
//                    try context.execute(deleteRequest)
//                    try context.save()
//                } catch {
//                    print ("There was an error")
//                }
//            print("Database purged")
//            }
    
}
