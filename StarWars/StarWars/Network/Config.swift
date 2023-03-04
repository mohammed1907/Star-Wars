//
//  Config.swift
//  StarWars
//
//  Created by Farghaly on 03/03/2023.
//

import Foundation

struct Config {
    static let baseURL: String = "https://swapi.dev/api/"
    
    struct EndpointPath {
        static let films = "films/"
    }
}
enum HTTPHeaderField: String {
    case authentication = "Authorization"
    case contentType = "Content-Type"
}

enum ContentType: String {
    case json = "application/json"
}
