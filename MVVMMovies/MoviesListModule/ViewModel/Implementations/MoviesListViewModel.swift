//
//  MoviesListViewModel.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 11.05.2021.
//

import Foundation

final class MoviesListViewModel: MoviesListViewModelProtocol {
    // MARK: - Public Properties

    var totalCount: Int {
        total
    }

    var currentCount: Int {
        movies.count
    }

    var playingMVVMMoviesCount: Int {
        playingMovies.count
    }

    var didFailedFetchingMoviesHandler: (() -> ())?
    var didFetchMoviesHandler: (([IndexPath]?) -> ())?
    var didFetchPlayingMoviesHandler: (() -> ())?

    // MARK: - Private Properties

    private var playingMovies: [Movie] = []
    private var movies: [Movie] = []
    private var total = 0
    private var currentPage = 0
    private var isFetchingInProgress = false
    private let moviesManager = MVVMMoviesManager()
    private var currentMovieType = MVVMMoviesListType.popular
    private var currentMVVMMoviesDownloadTask: URLSessionTask?

    // MARK: - Public Methods

    func fetchMovies() {
        guard currentMVVMMoviesDownloadTask == nil else {
            return
        }

        currentMVVMMoviesDownloadTask = moviesManager
            .fetchMovies(ofType: currentMovieType, page: currentPage + 1) { [weak self] result in
                self?.currentMVVMMoviesDownloadTask = nil

                switch result {
                case .failure:
                    self?.didFailedFetchingMoviesHandler?()
                case let .success(response):
                    self?.currentPage += 1

                    self?.total = response.totalResults
                    self?.movies.append(contentsOf: response.results)

                    if response.page > 1 {
                        let indexPathsToReload = self?.calculateIndexPathsToReload(from: response.results)
                        self?.didFetchMoviesHandler?(indexPathsToReload)
                    } else {
                        self?.didFetchMoviesHandler?(nil)
                    }
                }
            }
    }

    func fetchPlayingMovies() {
        moviesManager.fetchMovies(ofType: .playing, page: 1) { [weak self] result in
            switch result {
            case .failure:
                self?.didFailedFetchingMoviesHandler?()
            case let .success(response):
                self?.playingMovies.append(contentsOf: response.results)
                self?.didFetchPlayingMoviesHandler?()
            }
        }
    }

    func refreshMovies() {
        currentPage = 0
        movies = []

        fetchMovies()
        fetchPlayingMovies()
    }

    func selectMoviesType(at index: Int) {
        guard let selectedMVVMMoviesType = MVVMMoviesListType(rawValue: index) else {
            return
        }

        currentMovieType = selectedMVVMMoviesType

        currentPage = 0
        movies = []

        currentMVVMMoviesDownloadTask?.cancel()

        fetchMovies()
    }

    func movie(at index: Int) -> Movie {
        movies[index]
    }

    func playingMovie(at index: Int) -> Movie {
        playingMovies[index]
    }

    func calculateIndexPathsToReload(from newMVVMMovies: [Movie]) -> [IndexPath] {
        let startIndex = movies.count - newMVVMMovies.count
        let endIndex = startIndex + newMVVMMovies.count
        return (startIndex ..< endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
