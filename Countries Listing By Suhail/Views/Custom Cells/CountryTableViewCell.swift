//
//  CountryTableViewCell.swift
//  Project15.5-Milestone13-15
//
//  Created by suhail on 16/08/23.
//

import UIKit

class CountryTableViewCell: UITableViewCell {
    
    static let identifier = "CountryTableViewCell"
    static let nib = UINib(nibName: "CountryTableViewCell", bundle: nil)
    @IBOutlet var imgCountryName: UIImageView!
    @IBOutlet var lblCountryName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
