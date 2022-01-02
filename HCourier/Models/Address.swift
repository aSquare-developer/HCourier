//
//  Address.swift
//  HCourier
//
//  Created by Artur Anissimov on 02.01.2022.
//

import Foundation

struct Address {
    let street: String
    let houseNumber: String
    let apartamentNumber: String?
    let doorcode: String
    let description: String?
    
    var fullAddress: String {
        "\(street) \(houseNumber) - \(apartamentNumber ?? "")"
    }
    
    enum CodingKeys: String, CodingKey {
        case street
        case houseNumber = "house_number"
        case apartamentNumber = "appartment_number"
        case doorcode
        case description
    }
}

enum Link: String {
    case apiLink = "http://192.168.1.146:8383/api"
}
