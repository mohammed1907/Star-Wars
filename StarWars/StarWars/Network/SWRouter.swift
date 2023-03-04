//
//  SWRouter.swift
//  StarWars
//
//  Created by Farghaly on 03/03/2023.
//

import Foundation
enum SWRouter {

    // MARK: - Endpoints
    case getFilms
    case search(text: String)
    // MARK: - Properties
    var method: HTTPMethod {
        switch self {
        default:
            return .get
        }
    }

    var path: String {
        switch self {
        case .getFilms,.search:
            return Config.EndpointPath.films
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case .search(let text):
            let parameters = ["search": text] as [String: Any]
            return parameters
        default:
            return nil
        }
    }

    // MARK: - Methods
    func asURLRequest() throws -> URLRequest {
        let endpointPath: String = "\(Config.baseURL)\(path)"
        var components = URLComponents(string: endpointPath)
        var urlRequest = URLRequest(url: (components?.url)!)
        components?.queryItems = []
        urlRequest.httpMethod = method.rawValue
        urlRequest.setValue(ContentType.json.rawValue, forHTTPHeaderField: HTTPHeaderField.contentType.rawValue)
        if parameters != nil {
            components?.queryItems?.append(contentsOf: parameters!.map { (key, value) in
                URLQueryItem(name: key, value: value as? String)
            })
        }
        urlRequest.url = components?.url

        return urlRequest
    }
}
