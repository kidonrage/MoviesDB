//
//  DataResponseError.swift
//  MoviesDB
//
//  Created by Vlad Eliseev on 13.05.2021.
//

import Foundation

/// Ошибка выполнения запроса данных
enum DataResponseError: Error {
    case network
    case decoding
    case request

    var reason: String {
        switch self {
        case .decoding:
            return "Произошла ошибка при декодировании данных"
        case .network:
            return "Произошла ошибка при получении данных"
        case .request:
            return "Произошла ошибка при формировании сетевого запроса"
        }
    }
}
