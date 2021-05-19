//
//  MoviePhoto.swift
//  MoviesDB
//
//  Created by Vlad Eliseev on 14.05.2021.
//

import Foundation

/// Изображение для фильма
struct MoviePhoto: Decodable {
    let aspectRatio: Double?
    let filePath: String?
}

// MARK: - MoviePhoto

// extension MoviePhoto {
//    enum CodingKeys: String, CodingKey {
//        case aspectRatio = "aspect_ratio"
//        case filePath = "file_path"
//    }
// }
