//
//  DropDownViewController.swift
//  Countries Listing By Suhail
//
//  Created by suhail on 06/01/24.
//

import UIKit
import JGProgressHUD

class DropDownViewController: UIViewController {
    
    @IBOutlet var tblDropDown: UITableView!
    var completion : ((CountriesCD?) -> ())?
    var countries = [CountriesCD]()
    var networkManager = NetworkManager()
    let defaults = UserDefaults.standard
    let spinner = JGProgressHUD(style: .dark)
    
    @IBOutlet var btnBack: UIControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tblDropDown.delegate = self
        tblDropDown.dataSource = self
        networkManager.delegate = self
        giveBordersAndCornerRadius()
        
        let countriesCached = defaults.bool(forKey: "cachedCountries")
        if countriesCached{
            
            print("Reading from core data")
            if let fetchedResults = self.networkManager.fetchCachedCountries(){
                self.updateUI(parsedCountries: fetchedResults)
            }
        }else{
            
            print("Reading from api")
            spinner.show(in: view)
            networkManager.fetchData { [weak self] success in
                self?.defaults.set(true, forKey: "cachedCountries")
                if let fetchedResults = self?.networkManager.fetchCachedCountries(){
                    self?.updateUI(parsedCountries: fetchedResults)
                }
                
            }
        }
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.presentationController?.containerView?.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        self.presentationController?.containerView?.backgroundColor = UIColor.clear
    }
    
}
// MARK: - IBACtions
extension DropDownViewController{
    @IBAction func btnBackPressed(_ sender: UIControl) {
        self.dismiss(animated: true)
    }
}

// MARK: - UITableView Methods
extension DropDownViewController: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return countries.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = countries[indexPath.row].name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.dismiss(animated: true){  
            self.completion?(self.countries[indexPath.row])
        }
    }
}

// MARK: - Custom functions{
extension DropDownViewController{
    
    func giveBordersAndCornerRadius(){
        tblDropDown.layer.borderColor = UIColor.darkGray.cgColor
        tblDropDown.layer.borderWidth = 1
        tblDropDown.layer.cornerRadius = 12
        
        btnBack.layer.borderColor = UIColor.darkGray.cgColor
        btnBack.layer.borderWidth = 1
        
        btnBack.layer.cornerRadius = 12
        btnBack.layer.masksToBounds = true
        
    }
}

//NetworkManagerDelegate
extension DropDownViewController: NetworkManagerDelegate{
    
    func updateUI(parsedCountries: [CountriesCD]){
        self.countries = parsedCountries
        print("Back data retained")
        DispatchQueue.main.async(){ [weak self] in
            self?.spinner.dismiss()
            self?.tblDropDown.isHidden = false
            self?.btnBack.isHidden = false
            self?.tblDropDown.reloadData()
        }
    }
    
    func networkError(error: Error) {
        print("error sent toa to main")
        
        let alert = UIAlertController(title: "Alert", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default,handler: { _ in
            DispatchQueue.main.async{
                
                self.dismiss(animated: true)
            }
            
        }))
        
        DispatchQueue.main.async{
            self.spinner.dismiss()
            self.present(alert, animated: true)
        }
        
    }
    
}
