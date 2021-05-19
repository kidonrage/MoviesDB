//
//  MovieDetailsViewModelProtocol.swift
//  MoviesDB
//
//  Created by Vlad Eliseev on 12.05.2021.
//

import Foundation

protocol MovieDetailsViewModelProtocol: AnyObject {
    // MARK: - Public Properties

    var movie: Movie { get }
    var movieImagesCount: Int { get }
    var handleMovieImagesUpdate: (() -> ())? { get set }

    // MARK: - Public Methods

    func movieImageData(forImageAt indexPath: IndexPath) -> Data
    func fetchMovieImages()
}
