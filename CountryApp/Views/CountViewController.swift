//
//  CountViewController.swift
//  CountryApp
//
//  Created by Bharath Kapu on 4/14/25.
//

import UIKit
import Combine

final class CountViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private let viewModel = CountryViewModel()
    private let searchController = UISearchController(searchResultsController: nil)
    private var anyCancellableSet: Set<AnyCancellable> = []
    private let loadingIndicator = UIActivityIndicatorView(style: .large)
    
    private let errorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .red
        label.textAlignment = .center
        label.font = UIFont.preferredFont(forTextStyle: .title1)
        label.numberOfLines = 0
        label.isHidden = true
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        navigationItem.title = "Countries"
        tableView.dataSource = self
        setupSearchController()
        setupBindings()
        setupErrorLabel()
        viewModel.getCountries()
    }
    
    private func setupSearchController() {
        
        loadingIndicator.center = view.center
        view.addSubview(loadingIndicator)
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Countries"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    private func setupErrorLabel() {
        view.addSubview(errorLabel)
        errorLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            errorLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            errorLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            errorLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
    }
    private func setupBindings() {
        viewModel.$viewState.sink { [weak self] state in
            DispatchQueue.main.async {
                switch state {
                case .idle:
                    break
                case .loading:
                    self?.loadingIndicator.startAnimating()
                case .loaded(let countries):
                    self?.loadingIndicator.stopAnimating()
                    self?.errorLabel.isHidden = true
                    self?.tableView.reloadData()
                case .error(let errMsg):
                    self?.loadingIndicator.stopAnimating()
                    self?.errorLabel.text = errMsg
                    self?.errorLabel.isHidden = false
                }
            }
        }.store(in: &anyCancellableSet)
    }
}

extension CountViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.filteredCountries.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: CountryCell.id, for: indexPath) as? CountryCell
        let country = viewModel.filteredCountries[indexPath.row]
        cell?.configure(country: country)
        return cell ?? UITableViewCell()
    }
}

extension CountViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchText = searchController.searchBar.text ?? ""
        viewModel.filterCountries(by: searchText)
        tableView.reloadData()
    }
}
