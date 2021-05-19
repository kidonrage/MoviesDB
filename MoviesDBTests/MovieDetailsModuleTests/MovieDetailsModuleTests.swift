//
//  MovieDetailsModuleTests.swift
//  MoviesDBTests
//
//  Created by Vlad Eliseev on 19.05.2021.
//

@testable import MoviesDB
import XCTest

final class MovieDetailsModuleTests: XCTestCase {
    private var movie: Movie!
    private var movieImageService: MovieImagesServiceProtocol!
    private var movieDetailsViewModel: MovieDetailsViewModelProtocol!

    override func setUp() {
        movie = Movie(
            id: 0,
            title: "Title",
            posterPath: "/test",
            releaseDate: "10-05-2020",
            overview: "Overview",
            type: .playing
        )
        movieImageService = MovieImagesServiceMock()
        movieDetailsViewModel = MovieDetailViewModel(movie: movie, movieImagesService: movieImageService)
    }

    override func tearDown() {
        movie = nil
        movieImageService = nil
        movieDetailsViewModel = nil
    }

    func testImageURL() {
        let resolvedImageURL = movieImageService.getMovieImageURL(withPath: movie.posterPath ?? "")

        XCTAssertNotNil(resolvedImageURL)
    }
}
