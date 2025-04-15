//
//  EndPoint.swift
//  CountryApp
//
//  Created by Bharath Kapu on 4/14/25.
//

import Foundation

struct EndPoint {
    static func buildURL() throws -> URL {
        var urlcomponents = URLComponents()
        urlcomponents.scheme = "https"
        urlcomponents.host = "gist.githubusercontent.com"
        urlcomponents.path = "/peymano-wmt/32dcb892b06648910ddd40406e37fdab/raw/db25946fd77c5873b0303b858e861ce724e0dcd0/countries.json"
        
        guard let url = urlcomponents.url else {
            throw NetworkError.invalidURL
        }
        
        return url
    }
}
