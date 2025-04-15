//
//  NetworkError.swift
//  CountryApp
//
//  Created by Bharath Kapu on 4/14/25.
//

enum NetworkError: Error {
    case invalidURL
    case dataTaskFailed(Error)
    case decodingFailed(Error)
    case dataNotFound
    case unknownError
    case invalidResponse(Int)
}
