//
//  MovieImagesService.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 14.05.2021.
//

import Foundation

final class MovieImagesService: MovieImagesServiceProtocol {
    func getMoviePosterURL(withPath posterPath: String) -> URL? {
        URL(string: "http://image.tmdb.org/t/p/w342\(posterPath)")
    }
}
