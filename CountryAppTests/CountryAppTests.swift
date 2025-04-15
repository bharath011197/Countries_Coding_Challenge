//
//  CountryAppTests.swift
//  CountryAppTests
//
//  Created by Bharath Kapu on 4/14/25.
//

import XCTest
import Combine
@testable import CountryApp

final class CountryAppTests: XCTestCase {
    
    var viewModel: CountryViewModel!
    var mockNetworkManager: MockNetworkManager!
    
    override func setUpWithError() throws {
        mockNetworkManager = MockNetworkManager()
        viewModel = CountryViewModel(networkManager: mockNetworkManager)
    }
    override func tearDownWithError() throws {
        viewModel = nil
        mockNetworkManager = nil
    }
    
    func test_getCountries_success() async {
        let expectation = XCTestExpectation(description: "Data fetched successfully")
        let mockCountries = [Country(name: "India", region: "Asia", code: "IN", capital: "New Delhi")]
        mockNetworkManager.mockResult = .success(mockCountries)
        
        viewModel.getCountries()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.viewModel.filteredCountries.count, 1)
            XCTAssertNil(self.viewModel.errorMessage)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_getCountries_dataNotFound() {
        let expectation = XCTestExpectation(description: "No data found")
        mockNetworkManager.mockResult = .success([])
        viewModel.getCountries()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.viewModel.filteredCountries.count, 0)
            XCTAssertEqual(self.viewModel.errorMessage, "No data was found in the response")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_getCountries_error() {
        let expectation = XCTestExpectation(description: "Error Ocuured")
        let expectedError = NetworkError.invalidURL
        mockNetworkManager.mockResult = .failure(expectedError)
        viewModel.getCountries()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertEqual(self.viewModel.filteredCountries.count, 0)
            XCTAssertEqual(self.viewModel.errorMessage, ErrorHandler.handle(expectedError))
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_filterCountries_exactMatch_countryName() {
        let expectation = XCTestExpectation(description: "Filter function should work")

        let mockCountries = [
            Country(name: "India", region: "Asia", code: "IN", capital: "New Delhi"),
            Country(name: "United States", region: "North America", code: "USA", capital: "Washington D.C"),
            Country(name: "Canada", region: "North America", code: "CA", capital: "Ottawa")
        ]

        mockNetworkManager.mockResult = .success(mockCountries)
        
        viewModel.getCountries()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.viewModel.filterCountries(by: "Canada")
            XCTAssertEqual(self.viewModel.filteredCountries.count, 1)
            XCTAssertEqual(self.viewModel.filteredCountries.first?.name, "Canada")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_filterCountries_exactMatch_capital() {
        let expectation = XCTestExpectation(description: "Filter function should work for capital")

        let mockCountries = [
            Country(name: "India", region: "Asia", code: "IN", capital: "New Delhi"),
            Country(name: "United States", region: "North America", code: "USA", capital: "Washington D.C"),
            Country(name: "Canada", region: "North America", code: "CA", capital: "Ottawa")
        ]

        mockNetworkManager.mockResult = .success(mockCountries)
        
        viewModel.getCountries()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

            self.viewModel.filterCountries(by: "Ottawa")
            XCTAssertEqual(self.viewModel.filteredCountries.count, 1)
            XCTAssertEqual(self.viewModel.filteredCountries.first?.capital, "Ottawa")
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
    }
    
    func test_filterCountries_noMatch() {
        let expectation = XCTestExpectation(description: "Filter function should work for capital")

        let mockCountries = [
            Country(name: "India", region: "Asia", code: "IN", capital: "New Delhi"),
            Country(name: "United States", region: "North America", code: "USA", capital: "Washington D.C"),
            Country(name: "Canada", region: "North America", code: "CA", capital: "Ottawa")
        ]

        mockNetworkManager.mockResult = .success(mockCountries)
        
        self.viewModel.getCountries()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

        self.viewModel.filterCountries(by: "Mars")
            XCTAssertEqual(self.viewModel.filteredCountries.count, 0)
        expectation.fulfill()
    }
    wait(for: [expectation], timeout: 2.0)
    }
    
}



