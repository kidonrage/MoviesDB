//
//  PlayingMovieViewModelMock.swift
//  MoviesDBTests
//
//  Created by Vlad Eliseev on 19.05.2021.
//

import Foundation
@testable import MoviesDB

final class PlayingMovieViewModelMock: PlayingMovieViewModelProtocol {
    var movie: Movie

    var moviePosterURL: URL?

    init(movie: Movie) {
        self.movie = movie
        moviePosterURL = nil
    }
}
