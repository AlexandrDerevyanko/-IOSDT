//
//  NetworkService.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 09.03.2023.
//

import Foundation

enum AppConfiguration: String, CaseIterable {
    case peopleURL = "https://swapi.dev/api/people/5"
    case planetsURL = "https://swapi.dev/api/planets/2"
    case filmsURL = "https://swapi.dev/api/films/3"
}

protocol NetworkServiceProtocol {
    func request(for configuration: AppConfiguration)
}

class NetworkService: NetworkServiceProtocol {
    
    func request(for configuration: AppConfiguration) {
        
        guard let url = URL(string: configuration.rawValue) else {
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data,
                  let dictionary = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let text = dictionary["url"] as? String
            else {
                return
            }
            print(text)
            print(response as Any)
            print(error?.localizedDescription as Any)
        }
        task.resume()
    }

}
