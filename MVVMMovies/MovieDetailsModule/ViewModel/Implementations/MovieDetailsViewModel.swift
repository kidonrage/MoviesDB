//
//  MovieDetailsViewModel.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 12.05.2021.
//

import Foundation

final class MovieDetailViewModel: MovieDetailsViewModelProtocol {
    // MARK: - Public Properties

    var moviePosterURL: URL? {
        movieImagesService.getMoviePosterURL(withPath: movie.posterPath ?? "")
    }

    let movie: Movie

    // MARK: - Private Properties

    private let movieImagesService: MovieImagesServiceProtocol

    // MARK: - Initializers

    required init(movie: Movie, movieImagesService: MovieImagesServiceProtocol) {
        self.movie = movie
        self.movieImagesService = movieImagesService
    }
}
