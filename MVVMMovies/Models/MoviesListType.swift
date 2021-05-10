//
//  MVVMMoviesListType.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 12.03.2021.
//

import Foundation

/// Тип получаемого списка фильмов
enum MVVMMoviesListType: Int {
    case popular
    case topRated
    case upcoming
    case playing
}
