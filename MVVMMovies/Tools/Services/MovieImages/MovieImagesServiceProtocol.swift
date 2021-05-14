//
//  MovieImagesServiceProtocol.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 14.05.2021.
//

import Foundation

protocol MovieImagesServiceProtocol {
    func getMoviePosterURL(withPath posterPath: String) -> URL?
}
