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

    var currentMovieType = MoviesListType.popular

    var playingMovies: [Movie] = []
    var movies: [Movie] = []

    // MARK: - Private Properties

    private var total = 0
    private var currentPage = 0
    private var isFetchingInProgress = false
    private let moviesManager: MoviesManagerProtocol
    private var currentMoviesDownloadTask: URLSessionTask?

    // MARK: - Initializers

    init(moviesManager: MoviesManagerProtocol) {
        self.moviesManager = moviesManager

        movies = moviesManager.getCachedMovies(ofType: currentMovieType)
        total = movies.count

        playingMovies = moviesManager.getCachedMovies(ofType: .playing)
    }

    // MARK: - Public Methods

    func fetchMovies() {
        guard currentMoviesDownloadTask == nil else {
            return
        }

        currentMoviesDownloadTask = moviesManager
            .fetchMovies(ofType: currentMovieType, page: currentPage + 1) { [weak self] result in
                self?.currentMoviesDownloadTask = nil

                switch result {
                case .failure:
                    DispatchQueue.main.async {
                        self?.didFailedFetchingMoviesHandler?()
                    }
                case let .success(response):
                    self?.currentPage += 1

                    self?.total = response.totalResults

                    if response.page > 1 {
                        self?.movies.append(contentsOf: response.results)
                        let indexPathsToReload = self?.calculateIndexPathsToReload(from: response.results)
                        DispatchQueue.main.async {
                            self?.didFetchMoviesHandler?(indexPathsToReload)
                        }
                    } else {
                        self?.movies = response.results
                        DispatchQueue.main.async {
                            self?.didFetchMoviesHandler?(nil)
                        }
                    }
                }
            }
    }

    func fetchPlayingMovies() {
        moviesManager.fetchMovies(ofType: .playing, page: 1) { [weak self] result in
            switch result {
            case .failure:
                DispatchQueue.main.async {
                    self?.didFailedFetchingMoviesHandler?()
                }
            case let .success(response):
                self?.playingMovies.append(contentsOf: response.results)
                DispatchQueue.main.async {
                    self?.didFetchPlayingMoviesHandler?()
                }
            }
        }
    }

    func refreshMovies() {
        currentPage = 0

        fetchMovies()
        fetchPlayingMovies()
    }

    func selectMoviesType(at index: Int) {
        guard let selectedMVVMMoviesType = MoviesListType(rawValue: index) else {
            return
        }

        currentMovieType = selectedMVVMMoviesType

        currentPage = 0

        currentMoviesDownloadTask?.cancel()

        fetchMovies()
    }

    func movie(at index: Int) -> Movie {
        movies[index]
    }

    func playingMovie(at index: Int) -> Movie {
        playingMovies[index]
    }

    func playingMovieViewViewModel(forMovieAtIndexPath indexPath: IndexPath) -> PlayingMovieViewModelProtocol {
        let movie = playingMovie(at: indexPath.row)
        let viewModel = PlayingMovieViewModel(movie: movie, movieImagesService: MovieImagesService())

        return viewModel
    }

    func movieCellViewModel(forMovieAtIndexPath indexPath: IndexPath) -> MovieCellViewModelProtocol {
        let viewModel = MovieCellViewModel(movie: movie(at: indexPath.row), movieImagesService: MovieImagesService())

        return viewModel
    }
}
