//
//  Alerts.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 29.03.2023.
//

import UIKit

class Alert {
    
    static let defaulAlert = Alert()
    
    func errors(showIn viewController: UIViewController, error: AutorizationErrors) {
        let alertController = UIAlertController(title: "Ошибка", message: error.localizedDescription, preferredStyle: .alert)
        
        let alertOk = UIAlertAction(title: "Ok", style: .default)
        
        alertController.addAction(alertOk)
        viewController.present(alertController, animated: true)
    }
}
