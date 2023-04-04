////
////  DataJSON.swift
////  Navigation
////
////  Created by Aleksandr Derevyanko on 13.03.2023.
////
//
//import Foundation
//
//struct Data: Codable {
//    let userId, id: Int
//    let title: String
//    let completed: Bool
//}
//
//struct Planet: Codable {
//    let name, rotationPeriod, orbitalPeriod, diameter: String
//    let climate, gravity, terrain, surfaceWater: String
//    let population: String
//    let residents, films: [String]
//    let created, edited: String
//    let url: String
//
//    enum CodingKeys: String, CodingKey {
//        case name
//        case rotationPeriod = "rotation_period"
//        case orbitalPeriod = "orbital_period"
//        case diameter, climate, gravity, terrain
//        case surfaceWater = "surface_water"
//        case population, residents, films, created, edited, url
//    }
//}
