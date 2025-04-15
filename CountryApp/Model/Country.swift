//
//  Country.swift
//  CountryApp
//
//  Created by Bharath Kapu on 4/14/25.
//

import Foundation

struct Country: Decodable {
    let name: String
    let region: String
    let code: String
    let capital: String
}
