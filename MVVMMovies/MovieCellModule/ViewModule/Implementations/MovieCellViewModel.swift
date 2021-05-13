//
//  MovieCellViewModel.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 14.05.2021.
//

import Foundation

final class MovieCellViewModel: MovieCellViewModelProtocol {
    // MARK: - Public Properties

    let movie: Movie

    var moviePosterURL: URL? {
        movieImagesService.getMoviePosterURL(withPath: movie.posterPath ?? "")
    }

    // MARK: - Private Properties

    private let movieImagesService: MovieImagesServiceProtocol

    // MARK: - Initializers

    init(movie: Movie, movieImagesService: MovieImagesServiceProtocol) {
        self.movie = movie
        self.movieImagesService = movieImagesService
    }
}