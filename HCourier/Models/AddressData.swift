//
//  AddressData.swift
//  HCourier
//
//  Created by Artur Anissimov on 02.01.2022.
//

import Foundation

struct AddressData: Decodable {
    let street: String
    let houseNumber: String
    let apartamentNumber: String?
    let doorCode: String
    let desc: String?
    
    var fullAddress: String {
        "\(street) \(houseNumber) - \(apartamentNumber ?? "")"
    }
    
    enum CodingKeys: String, CodingKey {
        case street
        case houseNumber = "house_number"
        case apartamentNumber = "appartment_number"
        case doorCode = "doorcode"
        case desc = "description"
    }
}

enum Link: String {
    case apiLink = "http://192.168.1.146:8383/api"
}
