//
//  NetworkService.swift
//  Navigation
//
//  Created by Aleksandr Derevyanko on 09.03.2023.
//

import Foundation

protocol NetworkServiceProtocol {
    func titleRequest(completion: @escaping (String) -> Void)
    func orbitalPeriodRequest(completion: @escaping (String) -> Void)
    func peopleRequest(completion: @escaping ([String]) -> Void)
}

class NetworkService: NetworkServiceProtocol {
    
    func titleRequest(completion: @escaping (String) -> Void) {
        
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/3") else {
            completion("")
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion("")
                }
                return
            }
            do {
                let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                let titleText = dictionary!["title"] as? String
                DispatchQueue.main.async {
                    completion(titleText!)
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func orbitalPeriodRequest(completion: @escaping (String) -> Void) {
        
        guard let url = URL(string: "https://swapi.dev/api/planets/1") else {
            completion("")
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion("")
                }
                return
            }
            do {
                let period = try JSONDecoder().decode(Planet.self, from: data)
                DispatchQueue.main.async {
                    completion(period.orbitalPeriod)
                }
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }
    
    func peopleRequest(completion: @escaping ([String]) -> Void) {
        var array: [String] = []
        guard let url = URL(string: "https://swapi.dev/api/planets/1") else {
            completion([])
            print("Bad URL 1")
            return
        }
        let request = URLRequest(url: url)
        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
            guard let data = data else {
                DispatchQueue.main.async {
                    completion([])
                    print("Bad data")
                }
                return
            }
            do {
                let people = try JSONDecoder().decode(Planet.self, from: data)
                    for i in people.residents {
                        guard let url = URL(string: i) else {
                            print("Bad URL 2")
                            return
                        }
                        let request = URLRequest(url: url)
                        let task = URLSession.shared.dataTask(with: request) { data, _, _ in
                            guard let data = data else {
                                print("Bad data 2")
                                return
                            }
                            do {
                                
                                
                                let peopleName = try JSONDecoder().decode(People.self, from: data)
                                
                                array.append(peopleName.name)
                                DispatchQueue.main.async {
                                    completion(array)
                                }
                        }
                            catch {
                                print(error)
                            }
                        }
                        task.resume()
                    }
                
            }
            catch {
                print(error)
            }
        }
        task.resume()
    }

}
