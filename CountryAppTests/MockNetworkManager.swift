//
//  MockNetworkManager.swift
//  CountryApp
//
// Created by Bharath Kapu on 4/14/25.
//

import Combine
@testable import CountryApp
import Foundation

final class MockNetworkManager: NetworkActions {
    var mockResult: Result<[Country], NetworkError>?
    func fetchData<T: Decodable>(url: URL, modelType: T.Type) async throws -> T {
        guard let result = mockResult else {
            throw NetworkError.invalidURL
        }
        
        switch result {
        case .success(let data):
            guard let countries = data as? T else { throw NetworkError.invalidURL }
            return countries
        case .failure(let error):
            throw error
        }
    }
}
