//
//  DataResponseError.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 13.05.2021.
//

import Foundation

enum DataResponseError: Error {

    case network
    case decoding

    var reason: String {
        switch self {
        case .decoding:
            return "Произошла ошибка при декодировании данных"
        case .network:
            return "Произошла ошибка при получении данных"
        }
    }
    

}
