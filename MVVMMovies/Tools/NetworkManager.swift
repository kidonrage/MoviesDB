//
//  NetworkManager.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 10.03.2021.
//

import Foundation

final class NetworkManager {
    // MARK: - Private Properties

    private let basePath = "https://api.themoviedb.org/3/movie"
    private let key = "2bd6256c9f203894398972061a650620"

    // MARK: - Public Methods

    func getEndpointFetchingTask(
        _ endpointPath: String,
        parameters: [String: String]?,
        _ callback: @escaping (Data?) -> Void
    ) -> URLSessionTask? {
        var fullPath = "\(basePath)/\(endpointPath)?api_key=\(key)"

        for (key, value) in parameters ?? [:] {
            fullPath += "&\(key)=\(value)"
        }

        guard let url = URL(string: fullPath) else {
            return nil
        }

        print(fullPath)

        return URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let responseData = data else {
                callback(nil)
                return
            }

            callback(responseData)
        }
    }
}
