//
//  MoviesEndpoints.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 14.05.2021.
//

import Foundation

/// Эндпоинты фильмов
enum MVVMMoviesEndpoint: String {
    case topRated = "top_rated"
    case popular
    case playing = "now_playing"
    case upcoming
}
