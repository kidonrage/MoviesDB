//
//  MoviesListViewModelProtocol.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 11.05.2021.
//

import Foundation

protocol MoviesListViewModelProtocol: AnyObject {
    // MARK: - Public Properties

    var totalCount: Int { get }
    var currentCount: Int { get }
    var playingMVVMMoviesCount: Int { get }
    var didFailedFetchingMoviesHandler: (() -> ())? { get set }
    var didFetchMoviesHandler: ((_ newIndexPathsToReload: [IndexPath]?) -> ())? { get set }
    var didFetchPlayingMoviesHandler: (() -> ())? { get set }

    // MARK: - Public Methods

    func fetchMovies()
    func fetchPlayingMovies()
    func refreshMovies()
    func selectMoviesType(at index: Int)
    func movie(at index: Int) -> Movie
    func playingMovie(at index: Int) -> Movie
    func calculateIndexPathsToReload(from newMVVMMovies: [Movie]) -> [IndexPath]
}
