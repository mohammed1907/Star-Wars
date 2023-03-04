//
//  MovieService.swift
//  StarWars
//
//  Created by Farghaly on 03/03/2023.
//

import Foundation

protocol FilmService {
    func getFilm(completion: @escaping (Result<FilmModel, NetworkError>) -> Void)
    func search(searchText: String, completion: @escaping (Result<FilmModel, NetworkError>) -> Void)
}

class FilmServiceImplementation: FilmService {
    private let service = NetworkService()
    func getFilm(completion: @escaping (Result<FilmModel, NetworkError>) -> Void) {
        return service.fetchRequest(forRoute: .getFilms, completion: completion)
    }
    func search(searchText: String, completion: @escaping (Result<FilmModel, NetworkError>) -> Void) {
        return service.fetchRequest(forRoute: .search(text: searchText), completion: completion)
    }

}
