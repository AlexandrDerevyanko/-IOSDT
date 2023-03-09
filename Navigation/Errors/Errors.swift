//
//  Error.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 07.03.2023.
//

import Foundation

enum CustomError: Error {
    case invalidPassword
    case notFound
    case unexpected(code: Int)
}

extension CustomError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .invalidPassword:
            return NSLocalizedString("The provided username or password is invalid",
                                     comment: "Username or password is invalid")
        case .notFound:
            return NSLocalizedString("Error Description: The specified item could not be found.",
                                     comment: "Resource Not Found")
        case .unexpected(_):
            return NSLocalizedString("An unexpected error occurred.",
                                     comment: "Unexpected Error")
        }
    }
}

enum ImagesError: Error {
    case badURL
    case unexpected
}
