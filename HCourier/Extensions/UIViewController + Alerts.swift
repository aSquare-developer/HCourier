//
//  UIViewController + Alerts.swift
//  HCourier
//
//  Created by Artur Anissimov on 02.01.2022.
//

import Foundation
import UIKit

extension UIViewController {
    func customAlert(withTitle title: String, withMessage message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default)
        
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}
