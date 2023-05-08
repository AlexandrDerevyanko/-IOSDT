//
//  Error.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 07.03.2023.
//

import Foundation

enum AutorizationErrors: Error {
    case empty
    case invalidPassword
    case weakPassword
    case mismatchPassword
    case notFound
    case emailAlreadyInUse
    case invalidEmail
    case unexpected
    case autorization
}

extension AutorizationErrors: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .empty:
            return NSLocalizedString("You left an empty field",
                                     comment: "")
        case .invalidPassword:
            return NSLocalizedString("Incorrect email or password",
                                     comment: "")
        case .weakPassword:
            return NSLocalizedString("Password is less than 6 characters",
                                     comment: "")
        case .mismatchPassword:
            return NSLocalizedString("The entered passwords do not match",
                                     comment: "")
        case .notFound:
            return NSLocalizedString("Error Description: The specified item could not be found.",
                                     comment: "")
        case .emailAlreadyInUse:
            return NSLocalizedString("This email is already in use",
                                     comment: "")
        case .invalidEmail:
            return NSLocalizedString("Email entered incorrectly",
                                     comment: "")
        case .unexpected:
            return NSLocalizedString("Something went wrong",
                                     comment: "")
        case .autorization:
            return NSLocalizedString("Please login", comment: "")
        }
    }
}

enum ImagesError: Error {
    case badURL
    case unexpected
}

//
//return NSLocalizedString("Похоже, вы оставили пустое поле",
//                         comment: "")
//case .invalidPassword:
//return NSLocalizedString("Не верный email или пароль",
//                         comment: "")
//case .weakPassword:
//return NSLocalizedString("Пароль состоит менее чем из 6 символов",
//                         comment: "")
//case .mismatchPassword:
//return NSLocalizedString("Введенные пароли не совпадают",
//                         comment: "")
//case .notFound:
//return NSLocalizedString("Error Description: The specified item could not be found.",
//                         comment: "")
//case .emailAlreadyInUse:
//return NSLocalizedString("Такой email уже используется",
//                         comment: "")
//case .invalidEmail:
//return NSLocalizedString("Неверно введен email",
//                         comment: "")
//case .unexpected:
//return NSLocalizedString("Что то пошло не так",
//                         comment: "")
//case .autorization:
//return NSLocalizedString("Пожалуйста авторизируйтесь", comment: "")
//}
//}
