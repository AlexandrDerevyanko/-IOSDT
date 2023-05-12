//
//  Alerts.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 29.03.2023.
//

import UIKit

class AlertManager {
    
    static let defaulManager = AlertManager()
    
    func autorizationErrors(showIn viewController: UIViewController, error: AutorizationErrors) {
        let alertController = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        
        let alertOk = UIAlertAction(title: "Ok", style: .default)
        
        alertController.addAction(alertOk)
        viewController.present(alertController, animated: true)
    }
    
    func alert(title: String, message: String, okActionTitle: String, showIn viewController: UIViewController) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertOk = UIAlertAction(title: okActionTitle, style: .default)
        
        alertController.addAction(alertOk)
        viewController.present(alertController, animated: true)
    }
    
}
