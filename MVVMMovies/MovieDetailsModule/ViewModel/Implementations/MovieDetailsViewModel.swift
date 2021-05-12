//
//  MovieDetailsViewModel.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 12.05.2021.
//

import Foundation

final class MovieDetailViewModel: MovieDetailsViewModelProtocol {
    // MARK: - Public Properties

    let movie: Movie

    // MARK: - Initializers

    required init(movie: Movie) {
        self.movie = movie
    }
}
