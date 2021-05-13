//
//  MVVMMoviesManager.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 05.03.2021.
//

import UIKit

final class MVVMMoviesManager {
    // MARK: - Private Properties

    private let networkManager = NetworkManager()

    // MARK: - Public Methods

    @discardableResult
    func fetchMovies(
        ofType type: MVVMMoviesListType,
        page: Int,
        _ completionHandler: @escaping (Result<MVVMMoviesQueryResponse, DataResponseError>) -> Void
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
        ]) { (result: Result<MVVMMoviesQueryResponse, DataResponseError>) in
            completionHandler(result)
        }
    }

    static func getMoviePosterURL(withPath posterPath: String) -> URL? {
        URL(string: "http://image.tmdb.org/t/p/w342\(posterPath)")
    }
}

// MARK: - MVVMMoviesEndpoint

extension MVVMMoviesManager {
    enum MVVMMoviesEndpoint: String {
        case topRated = "top_rated"
        case popular
        case playing = "now_playing"
        case upcoming
    }
}
