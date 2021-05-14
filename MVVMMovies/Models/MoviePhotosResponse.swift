//
//  MoviePhotosResponse.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 14.05.2021.
//

import Foundation

/// Объект для парсинга ответа при запросе на изображения фильма
struct MoviePhotosResponse: Decodable {
    let id: Int
    let backdrops: [MoviePhoto]
}
