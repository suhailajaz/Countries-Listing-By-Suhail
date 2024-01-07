//
//  CountriesViewController.swift
//  Countries Listing By Suhail
//
//  Created by suhail on 06/01/24.
//

import UIKit
import SDWebImage
import JGProgressHUD
class CountriesViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {
    
    var countries = [CountriesCD]()
    var filteredCountries = [CountriesCD]()
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tblCountries: UITableView!{
        didSet{
            tblCountries.register(CountryTableViewCell.nib, forCellReuseIdentifier: CountryTableViewCell.identifier)
        }
    }
    let spinner = JGProgressHUD(style: .dark)
    var networkManager = NetworkManager()
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tblCountries.dataSource = self
        tblCountries.delegate = self
        networkManager.delegate = self
        title = "COUNTRIES"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "About", image: nil, target: self, action: #selector(aboutTheDeveloper))
        
        let countriesCached = defaults.bool(forKey: "cachedCountries")
        if countriesCached{
            //fetched from core data
            print("Read from core data")
            if let fetchedResults = self.networkManager.fetchCachedCountries(){
                self.countries = fetchedResults
                self.filteredCountries = fetchedResults
                DispatchQueue.main.async{
                    self.tblCountries.reloadData()
                }
            }
        }else{
            //read from Api
            print("Read from api")
            spinner.show(in: view)
            networkManager.fetchData { [weak self] success in
                self?.defaults.set(true, forKey: "cachedCountries")
                if let fetchedResults = self?.networkManager.fetchCachedCountries(){
                    self?.countries = fetchedResults
                    self?.filteredCountries = fetchedResults
                    DispatchQueue.main.async{
                        self?.spinner.dismiss(animated: true)
                        self?.tblCountries.reloadData()
                    }
                }
                
            }
        }
        
    }
    
    
    
}

extension CountriesViewController{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries.count
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let country = filteredCountries[indexPath.row]
        let imageURL = URL(string: country.flagLink ?? "no flag link")
        
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.identifier, for: indexPath) as! CountryTableViewCell
        cell.lblCountryName.text = country.name
        cell.imgCountryName.sd_setImage(with: imageURL,placeholderImage: UIImage(named: "suhail"))
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "wiki") as! WikipediaViewController
        vc.cityName = filteredCountries[indexPath.row].name
        navigationController?.pushViewController(vc, animated: true)
    }
    
    
    @objc func aboutTheDeveloper(){
        let ac = UIAlertController(title: "Developed by Sohail Ajaz", message: "This is a test app developed for demonstration at TrialX.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default))
        present(ac,animated: true)
    }
}

// MARK: - SEarch Bar Delegate methods
extension CountriesViewController: UISearchBarDelegate{
   func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredCountries = countries.filter({ $0.name?.lowercased().prefix(searchText.count) ?? "australia" == searchText.lowercased()
        })
        tblCountries.reloadData()
    }
    
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.text = ""
        filteredCountries = countries
        
        tblCountries.reloadData()
    }
}


// MARK: - Network Manager Delegate Methods
extension CountriesViewController: NetworkManagerDelegate{
    
    func networkError(error: Error) {
        
        let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Try Again?", style: .default,handler: { _ in
            DispatchQueue.main.async{
                
                self.viewDidLoad()
            }
            
        }))
        
        DispatchQueue.main.async{
            self.spinner.dismiss()
            self.present(alert, animated: true)
        }
        
    }
    
}
