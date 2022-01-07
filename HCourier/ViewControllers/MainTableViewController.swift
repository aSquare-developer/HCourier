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
    
    private var newAddresses: [AddressData] = [] {
        didSet {
            StorageManager.shared.deleteAllAddresses()
            
            addAddressesToCoreData(newAddresses)
            
            StorageManager.shared.saveContext()
            
            tableView.reloadData()
        }
    }
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
        setupSearchController()
        getDataFromServer(from: Link.apiLink.rawValue)
        getDataFromCoreData()

    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        isFiltering ? filteredAddress.count : addresses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.selectionStyle = .none
        var address: Address
        
        if isFiltering {
            address = filteredAddress[indexPath.row]
        } else {
            address = addresses[indexPath.row]
        }
        
        let fullAddress = "\(address.street ?? "") \(address.houseNumber ?? "") - \(address.apartamentNumber ?? "")"
        
        cell.title.text = fullAddress
        cell.detail.text = address.doorCode

        return cell
    }
    
    // MARK: - Private Methods
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.font = UIFont.boldSystemFont(ofSize: 17)
        }
    }
    
    private func getDataFromServer(from url: String) {
        NetworkManager.shared.fetchData(from: url) { result in
            switch result {
            case .success(let addresses):
                self.newAddresses = addresses
                self.tableView.reloadData()
            case .failure(let error):
                self.customAlert(withTitle: "Error!", withMessage: error.localizedDescription)
            }
        }
    }
    
    private func getDataFromCoreData() {
        StorageManager.shared.getAllAddresses(completion: { result in
            switch result {
            case .success(let address):
                self.addresses = address
                self.tableView.reloadData()
            case .failure(let error):
                self.customAlert(withTitle: "Error!", withMessage: error.localizedDescription)
            }
        })
    }
    
    private func addAddressesToCoreData(_ addresses: [AddressData]) {
        StorageManager.shared.addAddressesToCoreData(from: addresses)
    }
}

// MARK: - UISearchResultsUpdating
extension MainTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text ?? "")
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        filteredAddress = addresses.filter { address in
            guard let street = address.street else { return false }
            return street.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
}
