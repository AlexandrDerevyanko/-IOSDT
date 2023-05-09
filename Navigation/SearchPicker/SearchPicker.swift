//
//  SearchPicker.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 05.04.2023.
//

import UIKit

class SearchPicker {
    static let defaultPicker = SearchPicker()
    
    func getText(showPickerIn viewController: UIViewController, title: String, message: String, completion: ((_ text: String) -> ())?) {
        let alertController =  UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.addTextField()
        
        let alertOK = UIAlertAction(title: "Ok", style: .default) { alert in
            if let text = alertController.textFields?[0].text, text != "" {
                completion?(text)
            }
        }
        
        let alertCancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(alertOK)
        alertController.addAction(alertCancel)
        viewController.present(alertController, animated: true)
    }
    
}
