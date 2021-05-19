//
//  Movie.swift
//  MoviesDB
//
//  Created by Vlad Eliseev on 05.03.2021.
//

import Foundation

/// Фильм
struct Movie: Decodable {
    // MARK: - Public Properties

    let id: Int
    let title: String
    let posterPath: String?
    let releaseDate: String
    let overview: String

    var type: MoviesListType?

    // MARK: - Initializers

    init(dbMovie: DBMovie) {
        id = Int(dbMovie.id)
        title = dbMovie.title ?? ""
        posterPath = dbMovie.posterPath
        releaseDate = dbMovie.releaseDate ?? ""
        overview = dbMovie.overview ?? ""
        type = MoviesListType(rawValue: Int(dbMovie.type))
    }

    init(
        id: Int,
        title: String,
        posterPath: String?,
        releaseDate: String,
        overview: String,
        type: MoviesListType?
    ) {
        self.id = id
        self.title = title
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.overview = overview
        self.type = type
    }
}
