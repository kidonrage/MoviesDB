//
//  MovieCellViewModelProtocol.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 14.05.2021.
//

import Foundation

protocol MovieCellViewModelProtocol {
    var movie: Movie { get }
    var moviePosterURL: URL? { get }
}
