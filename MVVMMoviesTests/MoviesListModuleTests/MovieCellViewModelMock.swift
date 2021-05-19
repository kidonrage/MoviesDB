//
//  MovieCellViewModelMock.swift
//  MVVMMoviesTests
//
//  Created by Vlad Eliseev on 19.05.2021.
//

import Foundation
@testable import MVVMMovies

final class MovieCellViewModelMock: MovieCellViewModelProtocol {
    var movie: Movie

    var moviePosterURL: URL?

    init(movie: Movie) {
        self.movie = movie
        moviePosterURL = nil
    }
}
