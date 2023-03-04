//
//  ApiServiceMock.swift
//  StarWarsTests
//
//  Created by Farghaly on 04/03/2023.
//

import Foundation
@testable import StarWars

class ApiServiceMock: FilmService {
    var isFetchDataCalled = false
    var completeData: [FilmData] = [FilmData]()
    var completeClosure: ((Result<FilmModel, NetworkError>) -> Void)!
    var completeSearchData: FilmModel?
    var completeSearchClosure: ((Result<FilmModel, NetworkError>) -> Void)!

    func getFilm(completion: @escaping (Result<FilmModel, NetworkError>) -> Void) {
        isFetchDataCalled = true
        completeClosure = completion
    }

    func search(searchText text: String, completion: @escaping (Result<FilmModel, NetworkError>) -> Void) {
        isFetchDataCalled = true
        completeSearchClosure = completion
    }
}
