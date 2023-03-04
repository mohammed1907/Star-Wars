//
//  FilmSearchCellModel.swift
//  StarWars
//
//  Created by Farghaly on 04/03/2023.
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
