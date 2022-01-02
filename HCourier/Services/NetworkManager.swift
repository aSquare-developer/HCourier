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
    
    func fetchData(from url: String?, with completion: @escaping(Result<[Address], NetworkError>) -> Void) {
        guard let url = URL(string: url ?? "") else { return }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.invalidUrl))
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let addresses = try decoder.decode([Address].self, from: data)
                DispatchQueue.main.async {
                    completion(.success(addresses))
                }
            } catch {
                completion(.failure(.decodingError))
            }

        }.resume()
    }
    
}
