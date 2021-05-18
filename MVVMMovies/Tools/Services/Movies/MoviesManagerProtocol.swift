//
//  MoviesManagerProtocol.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 14.05.2021.
//

import Foundation

protocol MoviesManagerProtocol {
    func getCachedMovies(
        ofType type: MoviesListType
    ) -> [Movie]

    @discardableResult
    func fetchMovies(
        ofType type: MoviesListType,
        page: Int,
        _ completionHandler: @escaping (Result<MoviesQueryResponse, DataResponseError>) -> Void
    ) -> URLSessionDataTask?
}
