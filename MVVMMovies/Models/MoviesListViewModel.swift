//
//  MVVMMoviesListViewModel.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 12.03.2021.
//

import Foundation

final class MVVMMoviesListViewModel {
    // MARK: - Public Properties

    weak var delegate: MVVMMoviesListViewModelDelegate?
    var totalCount: Int {
        total
    }

    var currentCount: Int {
        movies.count
    }

    var playingMVVMMoviesCount: Int {
        playingMVVMMovies.count
    }

    // MARK: - Private Properties

    private var playingMVVMMovies: [Movie] = []
    private var movies: [Movie] = []
    private var total = 0
    private var currentPage = 0
    private var isFetchingInProgress = false
    private let moviesManager = MVVMMoviesManager()
    private var currentMovieType = MVVMMoviesListType.popular
    private var currentMVVMMoviesDownloadTask: URLSessionTask?

    // MARK: - Public Methods

    func fetchMVVMMovies() {
        currentMVVMMoviesDownloadTask = moviesManager
            .getMovieFetchTask(ofType: currentMovieType, page: currentPage + 1) { response in
                guard let successResponse = response else {
                    DispatchQueue.main.async {
                        self.delegate?.didFailedFetchingMVVMMovies()
                    }
                    return
                }

                DispatchQueue.main.async {
                    self.currentPage += 1

                    self.total = successResponse.totalResults
                    self.movies.append(contentsOf: successResponse.results)

                    if successResponse.page > 1 {
                        let indexPathsToReload = self.calculateIndexPathsToReload(from: successResponse.results)
                        self.delegate?.didFetchMVVMMovies(with: indexPathsToReload)
                    } else {
                        self.delegate?.didFetchMVVMMovies(with: nil)
                    }
                }
            }

        currentMVVMMoviesDownloadTask?.resume()
    }

    func fetchPlayingMVVMMovies() {
        let task = moviesManager.getMovieFetchTask(ofType: .playing, page: 1) { response in
            guard let successResponse = response else {
                DispatchQueue.main.async {
                    self.delegate?.didFailedFetchingMVVMMovies()
                }
                return
            }

            DispatchQueue.main.async {
                self.playingMVVMMovies.append(contentsOf: successResponse.results)

                self.delegate?.didFetchPlayingMVVMMovies()
            }
        }

        task?.resume()
    }

    func selectMVVMMoviesType(at index: Int) {
        guard let selectedMVVMMoviesType = MVVMMoviesListType(rawValue: index) else {
            return
        }

        currentMovieType = selectedMVVMMoviesType

        currentPage = 0
        movies = []

        currentMVVMMoviesDownloadTask?.cancel()

        fetchMVVMMovies()
    }

    @objc func refreshMVVMMovies() {
        currentPage = 0
        movies = []

        fetchMVVMMovies()
        fetchPlayingMVVMMovies()
    }

    func movie(at index: Int) -> Movie {
        movies[index]
    }

    func playingMovie(at index: Int) -> Movie {
        playingMVVMMovies[index]
    }

    // MARK: - Private Methods

    private func calculateIndexPathsToReload(from newMVVMMovies: [Movie]) -> [IndexPath] {
        let startIndex = movies.count - newMVVMMovies.count
        let endIndex = startIndex + newMVVMMovies.count
        return (startIndex ..< endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
