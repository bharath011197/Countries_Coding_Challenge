
//
//  NetworkError.swift
//  CountryApp
//
//  Created by Bharath Kapu on 4/14/25.
//

import Foundation

protocol NetworkActions {
    func fetchData<T: Decodable>(url: URL, modelType: T.Type) async throws -> T
}

final class NetworkManager {
    
    let urlSession:URLSession
    init(urlSession: URLSession = URLSession.shared) {
        self.urlSession = urlSession
    }
    
}
extension NetworkManager:NetworkActions{
    func fetchData<T: Decodable>(url: URL, modelType: T.Type) async throws -> T {
        do {
            let (data, response) = try await self.urlSession.data(from: url)
            try validateResponse(response)
            guard !data.isEmpty else {
                throw NetworkError.dataNotFound
            }
            return try JSONDecoder().decode(modelType, from: data)
        } catch {
            throw NetworkError.unknownError
        }
    }
    
    private func validateResponse(_ response: URLResponse) throws {
        guard let response = response as? HTTPURLResponse else {
            throw NetworkError.dataTaskFailed(NSError(domain: "Invalid response", code: -1))
        }
        
        switch response.statusCode {
        case 200...299:
            break
        default:
            throw NetworkError.invalidResponse(response.statusCode)
        }
    }
}
