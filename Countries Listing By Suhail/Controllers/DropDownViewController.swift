//
//  DropDownViewController.swift
//  Countries Listing By Suhail
//
//  Created by suhail on 06/01/24.
//

import UIKit

class DropDownViewController: UIViewController {

    @IBOutlet var tblDropDown: UITableView!
    var completion : ((Country?) -> ())?
    var countries = [Country]()
    var networkManager = NetworkManager()
    override func viewDidLoad() {
        super.viewDidLoad()
            
        tblDropDown.delegate = self
        tblDropDown.dataSource = self
        networkManager.delegate = self
        giveBordersAndCornerRadius()
        
        
        networkManager.fetchData()
    }
    

   
}
//IBACTIONS
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
        cell.textLabel?.text = countries[indexPath.row].name.common
       
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
    }
}

//NetworkManagerDelegate
extension DropDownViewController: NetworkManagerDelegate{
    
    func updateUI(parsedCountries: [Country]){
        self.countries = parsedCountries.sorted { $0.name.common.localizedCaseInsensitiveCompare($1.name.common) == .orderedAscending }
        print("Back data retained")
        DispatchQueue.main.async(){ [weak self] in
            self?.tblDropDown.reloadData()
        }
    }
    
    
}
