//
//  NetworkManager.swift
//  HCourier
//
//  Created by Artur Anissimov on 02.01.2022.
//

import Foundation

enum NetworkError: Error {
    case invalidUrl
    case noData
    case decodingError
}

class NetworkManager {
    
    static let shared = NetworkManager()
    
    private init() {}
    
    func fetchData() {
        
    }
    
}
