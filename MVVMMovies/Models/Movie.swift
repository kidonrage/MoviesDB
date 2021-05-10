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
    let popularity: Double
    let adult: Bool
    let genreIds: [Int]
    let voteAverage: Float
    let voteCount: Int
}
