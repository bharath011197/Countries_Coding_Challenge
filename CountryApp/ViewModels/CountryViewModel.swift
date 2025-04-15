//
//  CountryViewModel.swift
//  CountryApp
//
//  Created by Bharath Kapu on 4/14/25.
//

import Foundation

enum ViewState {
    case idle
    case loading
    case loaded([Country])
    case error(String)
}

final class CountryViewModel {
    private var countries: [Country] = []
    var filteredCountries: [Country] = []
    var errorMessage: String?
    @Published var viewState: ViewState = .idle
    
    private let networkManager: NetworkActions
   
    init(networkManager: NetworkActions = NetworkManager()) {
        self.networkManager = networkManager
    }
    
    func getCountries() {
        viewState = .loading
        Task {
            do {
                let fetchedCountries = try await networkManager.fetchData(url: EndPoint.buildURL(), modelType: [Country].self)
                if fetchedCountries.isEmpty {
                    errorMessage = ErrorHandler.handle(.dataNotFound)
                    viewState = .error(errorMessage ?? "Unknown Error Occurred")
                }else {
                    countries = fetchedCountries
                    filteredCountries = fetchedCountries
                    viewState = .loaded(filteredCountries)
                }
            }catch let error{
                switch error{
                case is DecodingError:
                    errorMessage = "Parsing Error"
                case is URLError:
                    errorMessage = "Invalid Url"
                case .dataNotFound as NetworkError:
                    errorMessage = ErrorHandler.handle(error as? NetworkError ?? NetworkError.unknownError)
                case .decodingFailed(let decodingError) as NetworkError:
                    errorMessage = ErrorHandler.handle(decodingError as? NetworkError ?? NetworkError.unknownError)
                case .invalidURL as NetworkError:
                    errorMessage = ErrorHandler.handle(error as? NetworkError ?? NetworkError.unknownError)
                default:
                    errorMessage = "An unknown error occurred."
                }
                viewState = .error(errorMessage ?? "Unknown Error Occurred")
            }
        }
    }
    
    func filterCountries(by searchText: String) {
        filteredCountries = searchText.isEmpty
        ? countries
        : countries.filter { $0.name.lowercased().contains(searchText.lowercased()) ||
            $0.capital.lowercased().contains(searchText.lowercased()) }
    }
}
