//
//  CheckerService.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 11.05.2023.
//

import Foundation

protocol CheckServiceProtocol {
    func check(text: String) -> Bool
}

final class CheckService: CheckServiceProtocol {
    
    static let defaultCheckService = CheckService()
    
    private var password: String = "1234"
    
    func check(text: String) -> Bool {
        if text == password {
            return true
        } else {
            return false
        }
    }
    
}
