//
//  MoviesListViewModelProtocol.swift
//  MoviesDB
//
//  Created by Vlad Eliseev on 11.05.2021.
//

import Foundation

protocol MoviesListViewModelProtocol: AnyObject {
    // MARK: - Public Properties

    var totalCount: Int { get }
    var currentCount: Int { get }
    var playingMoviesCount: Int { get }
    var didFailedFetchingMoviesHandler: (() -> ())? { get set }
    var didFetchMoviesHandler: ((_ newIndexPathsToReload: [IndexPath]?) -> ())? { get set }
    var didFetchPlayingMoviesHandler: (() -> ())? { get set }
    var currentMovieType: MoviesListType { get set }
    var movies: [Movie] { get set }
    var playingMovies: [Movie] { get set }

    // MARK: - Public Methods

    func fetchMovies()
    func fetchPlayingMovies()
    func refreshMovies()
    func selectMoviesType(at index: Int)
    func movie(at index: Int) -> Movie
    func playingMovie(at index: Int) -> Movie
    func calculateIndexPathsToReload(from newMovies: [Movie]) -> [IndexPath]
    func playingMovieViewViewModel(forMovieAtIndexPath indexPath: IndexPath) -> PlayingMovieViewModelProtocol
    func movieCellViewModel(forMovieAtIndexPath indexPath: IndexPath) -> MovieCellViewModelProtocol
}

extension MoviesListViewModelProtocol {
    func calculateIndexPathsToReload(from newMovies: [Movie]) -> [IndexPath] {
        let startIndex = movies.count - newMovies.count
        let endIndex = startIndex + newMovies.count
        return (startIndex ..< endIndex).map { IndexPath(row: $0, section: 0) }
    }
}
