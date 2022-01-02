//
//  MainTableViewController.swift
//  HCourier
//
//  Created by Artur Anissimov on 02.01.2022.
//

import UIKit

class MainTableViewController: UITableViewController {
    
    // MARK: - Private Methods
    private var addresses: [Address] = []
    private let searchController = UISearchController(searchResultsController: nil)
    private var filteredAddress: [Address] = []
    private var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    

    // MARK: - Ovveride Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupSearchController()
        fetchData(from: Link.apiLink.rawValue)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteredAddress.count : addresses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        var address: Address
        
        if isFiltering {
            address = filteredAddress[indexPath.row]
        } else {
            address = addresses[indexPath.row]
        }
        
        var content = cell.defaultContentConfiguration()
        content.text = address.fullAddress
        content.secondaryText = address.doorCode
        cell.contentConfiguration = content

        return cell
    }
    
    // MARK: - Private Methods
    private func setupNavigationBar() {
        title = "Addresses"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
//        searchController.searchBar.barTintColor = .black
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont.boldSystemFont(ofSize: 17)
//            textField.textColor = .black
        }
    }
    
    private func fetchData(from url: String) {
        NetworkManager.shared.fetchData(from: url) { result in
            switch result {
            case .success(let addresses):
                self.addresses = addresses
                self.tableView.reloadData()
            case .failure(let error):
                self.customAlert(withTitle: "Error!", withMessage: error.localizedDescription)
            }
        }
    }

}

// MARK: - UISearchR
extension MainTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredAddress = addresses.filter { address in
            address.street.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
}
