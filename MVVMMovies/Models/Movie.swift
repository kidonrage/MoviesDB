//
//  Movie.swift
//  MVVMMovies
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

    init(dbMovie: DBMovie) {
        id = Int(dbMovie.id)
        title = dbMovie.title ?? ""
        posterPath = dbMovie.posterPath
        releaseDate = dbMovie.releaseDate ?? ""
        overview = dbMovie.overview ?? ""
        type = MoviesListType(rawValue: Int(dbMovie.type))
    }
}
