//
//  NetworkManager.swift
//  Countries Listing By Suhail
//
//  Created by suhail on 06/01/24.
//

import Foundation
protocol NetworkManagerDelegate{
    func updateUI(parsedCountries: [Country])
}

struct NetworkManager{
    
    var delegate: NetworkManagerDelegate?
    
    
    func fetchData(){
        let urlString = "https://restcountries.com/v3.1/all"

            if let url = URL(string: urlString){
                    parseJSON(url: url)

            }else{
                print("error 2")
            }
        
        
    }
    
    func parseJSON(url: URL){
        print("fetching data from API")
        URLSession.shared.dataTask(with: url) { data, response, error in
                  if let error = error {
                      print("Error 1: \(error.localizedDescription)")
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
                          DatabaseManager.shared.cacheQuestionsToLocalDB(parsedCountries: countryData) { success in
                              print("Data sucessfully cached")
                          }
                          //delegate?.updateUI(parsedCountries: countryData)
                        

                      } catch {
                          print("JSON decoding error: \(error.localizedDescription)")
                      }
                  }
              }.resume()
    }
    
}
