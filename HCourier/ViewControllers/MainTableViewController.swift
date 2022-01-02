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

    // MARK: - Ovveride Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchData(from: Link.apiLink.rawValue)
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        addresses.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let address = addresses[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = address.fullAddress
        content.secondaryText = address.doorCode
        cell.contentConfiguration = content

        return cell
    }
    
    // MARK: - Private Methods
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
