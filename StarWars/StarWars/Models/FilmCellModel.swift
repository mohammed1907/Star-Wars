//
//  FilmCellModel.swift
//  StarWars
//
//  Created by Farghaly on 04/03/2023.
//

import Foundation

struct FilmCellModel {
    let title: String
    let releaseDate: String
    let description: String
    let director: String
    let producer: String
    init(data: FilmData) {
        self.title = data.title
        self.releaseDate = data.releaseDate
        self.description = data.openingCrawl
        self.director = data.director
        self.producer = data.producer
    }
}
