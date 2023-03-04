//
//  FilmSearchCellModel.swift
//  StarWars
//
//  Created by Omar Hassanein on 04/03/2023.
//

import Foundation

struct FilmSearchCellModel {
    let title: String
    let director: String
    init(data: FilmData) {
        self.title = data.title
        self.director = data.director

    }
}
