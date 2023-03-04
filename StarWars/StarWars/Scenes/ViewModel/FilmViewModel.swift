//
//  FilmViewModel.swift
//  StarWars
//
//  Created by Farghaly on 03/03/2023.
//

import Foundation

protocol FilmViewModelLogic {
    // MARK: Properties
    var alertMessage: String? { get }
    var state: State { get }
    var numberOfSearchCells: Int { get }
    var numberOfFilmCells: Int { get }

    // MARK: Actions
    func getFilms()
    func search(text: String)
    func getSearchCellViewModel( at indexPath: IndexPath ) -> FilmSearchCellModel
    func getFilmCellViewModel( at indexPath: IndexPath ) -> FilmCellModel
    func emptySearchResult()
    var showAlertClosure: (() -> Void)? { get set }
    var updateLoadingStatus: (() -> Void)? { get set }
    var reloadFilmTableViewClosure: (() -> Void)? { get set }
    var reloadSearchTableViewClosure: (() -> Void)? { get set }
    
}

class FilmViewModel: FilmViewModelLogic {
    
    private let apiService: FilmService

    init(apiService: FilmService = FilmServiceImplementation()) {
        self.apiService = apiService
    }

    // MARK: - API result
    private var filmaData: [FilmData] = [FilmData]() {
        didSet {
            self.processFilmData(data: filmaData)
        }
    }
    private var searchResult: [FilmData] = [FilmData]() {
        didSet {
            self.processSearchData(data: searchResult)
        }
    }

    // MARK: - fetched result from FilmCellModel
    private var searchResultData: [FilmSearchCellModel] = [FilmSearchCellModel]() {
        didSet {
            self.reloadSearchTableViewClosure?()
        }
    }
    var numberOfSearchCells: Int {
        return searchResultData.count
    }
    private var filmResultData: [FilmCellModel] = [FilmCellModel]() {
        didSet {
            self.reloadFilmTableViewClosure?()
        }
    }
    var numberOfFilmCells: Int {
        return filmResultData.count
    }
    
    // MARK: - callback for interfaces
    var state: State = .empty {
        didSet {
            self.updateLoadingStatus?()
        }
    }
    var alertMessage: String? {
        didSet {
            self.showAlertClosure?()
        }
    }

    // MARK: closures for binding
    var showAlertClosure: (() -> Void)?
    var updateLoadingStatus: (() -> Void)?
    var reloadFilmTableViewClosure: (() -> Void)?
    var reloadSearchTableViewClosure: (() -> Void)?
    // MARK: - prepare film data
    private func processFilmData(data: [FilmData]?) {
        self.filmResultData = data?.compactMap { FilmCellModel(data: $0) } ?? []
    }

    // MARK: - process fetched result
    private func processSearchData(data: [FilmData]?) {
        self.searchResultData = data?.compactMap { FilmSearchCellModel(data: $0) } ?? []
    }

    func getSearchCellViewModel( at indexPath: IndexPath ) -> FilmSearchCellModel {
        return searchResultData[indexPath.row]
    }
    func getFilmCellViewModel( at indexPath: IndexPath ) -> FilmCellModel {
        return filmResultData[indexPath.row]
    }
    func emptySearchResult() {
        searchResultData.removeAll()
        searchResult.removeAll()
        reloadSearchTableViewClosure?()
    }

}
// MARK: - Network Calls
extension FilmViewModel {
    func getFilms() {
        state = .loading
        apiService.getFilm{[weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let data):
              self.filmaData = data.results
              self.state = .populated
            case .failure(let error):
                self.state = .error
                self.alertMessage = error.errorDescription
                    return
            }

        }
    }
    func search(text: String) {
        state = .loading
        apiService.search(searchText: text) {[weak self] result in
            guard let self = self else {
                return
            }
            switch result {
            case .success(let data):
              self.searchResult = data.results
              self.state = .populated
            case .failure(let error):
                self.state = .error
                self.alertMessage = error.errorDescription
                    return
            }

        }
    }
}
