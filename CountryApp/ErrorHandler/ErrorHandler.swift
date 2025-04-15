//
//  ErrorHandler.swift
//  CountryApp
//
//  Created by Bharath Kapu on 4/14/25.
//

import Foundation

struct ErrorHandler {
    static func handle(_ error: NetworkError) -> String {
        switch error {
        case .invalidURL:
            return "The URL provided is invalid. Please check the endpoint and try again."
            
        case .dataTaskFailed(let error):
            return "Network request failed: \(error.localizedDescription). Please check your internet connection."
            
        case .decodingFailed(let error):
            return "Failed to decode the response data. \(error.localizedDescription)"
            
        case .dataNotFound:
            return "No data was found in the response"
            
        case .unknownError:
            return "Unknowne Error Occured"
            
        case .invalidResponse(let code):
            return "Got Invalid Response with code \(code)"
        }
    }
}
