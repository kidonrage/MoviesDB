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

    func getMovieFetchTask(
        ofType type: MVVMMoviesListType,
        page: Int,
        _ callback: @escaping (MVVMMoviesQueryResponse?) -> Void
    ) -> URLSessionTask? {
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

        return networkManager.getEndpointFetchingTask(
            enpoint.rawValue,
            parameters: [
                "language": "ru",
                "page": "\(page)"
            ]
        ) { data in
            DispatchQueue.main.async {
                callback(self.parsedResponseFromFetchedData(data))
            }
        }
    }

    static func getMoviePosterURL(withPath posterPath: String) -> URL? {
        URL(string: "http://image.tmdb.org/t/p/w342\(posterPath)")
    }

    // MARK: - Private Methods

    private func parsedResponseFromFetchedData(_ data: Data?) -> MVVMMoviesQueryResponse? {
        guard let responseData = data else {
            return nil
        }

        var response: MVVMMoviesQueryResponse?

        do {
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .convertFromSnakeCase

            response = try decoder.decode(MVVMMoviesQueryResponse.self, from: responseData)
        } catch {
            print(error)
            return nil
        }

        return response
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
