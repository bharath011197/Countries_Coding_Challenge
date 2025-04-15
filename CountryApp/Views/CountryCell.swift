//
//  CountryCell.swift
//  CountryApp
//
//  Created by Bharath Kapu on 4/14/25.
//

import UIKit

final class CountryCell: UITableViewCell {
    static let id = "CountryCell"
    
    @IBOutlet weak var nameAndRegionLbl: UILabel!
    
    @IBOutlet weak var codeLbl: UILabel!
    
    @IBOutlet weak var capitalLbl: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        isAccessibilityElement = true
        accessibilityTraits = .staticText
    }
    
    func configure(country: Country) {
        nameAndRegionLbl.text = country.name + ", " + country.region
        codeLbl.text = country.code
        capitalLbl.text = country.capital
        
        nameAndRegionLbl.textColor = .label
        capitalLbl.textColor = .secondaryLabel
        codeLbl.textColor = .secondaryLabel
        
        nameAndRegionLbl.font = UIFont.preferredFont(forTextStyle: .headline)
        capitalLbl.font = UIFont.preferredFont(forTextStyle: .body)
        codeLbl.font = UIFont.preferredFont(forTextStyle: .subheadline)
        
        [nameAndRegionLbl, capitalLbl, codeLbl].forEach {
            $0?.adjustsFontForContentSizeCategory = true
            
            accessibilityLabel = "Country Information"
            accessibilityValue = """
                   \(country.name), 
                   Region: \(country.region), 
                   Capital city: \(country.capital), 
                   Country code: \(country.code)
                   """
        }
        
    }
}
