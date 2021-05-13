//
//  MoviesQueryResponse.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 05.03.2021.
//

import Foundation

/// Результат запроса на список фильмов
struct MoviesQueryResponse: Decodable {
    let results: [Movie]
    let page: Int
    let totalResults: Int
}
