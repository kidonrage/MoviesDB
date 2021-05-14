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
        movieImagesService.getMovieImageURL(withPath: movie.posterPath ?? "")
    }

    var movieImagesCount: Int {
        movieImagesData.count
    }

    let movie: Movie

    var handleMovieImagesUpdate: (() -> ())?

    // MARK: - Private Properties

    private var movieImagesData: [Data] = [] {
        didSet {
            handleMovieImagesUpdate?()
        }
    }

    private let movieImagesService: MovieImagesServiceProtocol

    // MARK: - Initializers

    required init(movie: Movie, movieImagesService: MovieImagesServiceProtocol) {
        self.movie = movie
        self.movieImagesService = movieImagesService
    }

    // MARK: - Public Methods

    func fetchMovieImages() {
        movieImagesService.fetchImages(ofMovieWithId: movie.id) { [weak self] result in
            switch result {
            case let .failure(error):
                print("Oh error \(error.localizedDescription)")
            case let .success(photos):
                let imagesPaths = photos.compactMap(\.filePath)
                self?.fetchImagesFromPaths(imagesPaths)
            }
        }
    }

    func movieImageData(forImageAt indexPath: IndexPath) -> Data {
        movieImagesData[indexPath.row]
    }

    // MARK: - Private Methods

    private func fetchImagesFromPaths(_ paths: [String]) {
        var imagesData: [Data] = []

        let dispatchGroup = DispatchGroup()

        for path in paths {
            dispatchGroup.enter()

            movieImagesService.fetchImageData(imagePath: path) { result in
                switch result {
                case let .success(data):
                    imagesData.append(data)
                default:
                    break
                }

                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) { [weak self] in
            self?.movieImagesData = imagesData
        }
    }
}
