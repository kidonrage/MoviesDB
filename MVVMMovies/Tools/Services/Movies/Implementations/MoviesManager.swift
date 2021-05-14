//
//  MoviesManager.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 05.03.2021.
//

import Foundation

final class MoviesManager: MoviesManagerProtocol {
    // MARK: - Private Properties

    private let networkManager = NetworkManager()

    // MARK: - Public Methods

    @discardableResult
    func fetchMovies(
        ofType type: MoviesListType,
        page: Int,
        _ completionHandler: @escaping (Result<MoviesQueryResponse, DataResponseError>) -> Void
    ) -> URLSessionDataTask? {
        let enpoint: MVVMMoviesEndpoint
        switch type {
        case .playing:
            enpoint = .playing
        case .popular:
            enpoint = .popular
        case .topRated:
            enpoint = .topRated
        case .upcoming:
            enpoint = .upcoming
        }

        return networkManager.executeDecodableDataTask(withEndpointPath: enpoint.rawValue, parameters: [
            "language": "ru",
            "page": "\(page)"
        ]) { result in
            completionHandler(result)
        }
    }
}
