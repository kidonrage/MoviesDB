//
//  NetworkManager.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 10.03.2021.
//

import Foundation

final class NetworkManager: NetworkServiceProtocol {
    // MARK: - Private Properties

    private let scheme = "https"
    private let host = "api.themoviedb.org"
    private let basePath = "/3/movie"
    private let key = "2bd6256c9f203894398972061a650620"

    // MARK: - Public Methods

    @discardableResult
    func executeDecodableDataTask<T: Decodable>(
        withEndpointPath endpointPath: String,
        parameters: [String: String]?,
        _ callback: @escaping (Result<T, DataResponseError>) -> Void
    ) -> URLSessionDataTask? {
        guard let task = getDataTask(
            withEndpointPath: endpointPath,
            parameters: parameters,
            completionHandler: { data, _, error in
                guard
                    error == nil,
                    let data = data
                else {
                    callback(.failure(.network))
                    return
                }

                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase

                guard let decodedData = try? decoder.decode(T.self, from: data) else {
                    callback(.failure(.decoding))
                    return
                }

                callback(.success(decodedData))
            }
        ) else {
            callback(.failure(.request))
            return nil
        }

        task.resume()

        return task
    }

    @discardableResult
    func executeDataTask(
        with url: URL,
        parameters: [String: String]?,
        _ callback: @escaping (Result<Data, DataResponseError>) -> Void
    ) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { data, _, error in
            guard
                error == nil,
                let data = data
            else {
                callback(.failure(.network))
                return
            }

            callback(.success(data))
        }

        task.resume()

        return task
    }

    // MARK: - Private Methods

    private func getDataTask(
        withEndpointPath endpointPath: String,
        parameters: [String: String]?,
        completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask? {
        var urlComponents = URLComponents()
        urlComponents.scheme = scheme
        urlComponents.host = host
        urlComponents.path = "\(basePath)/\(endpointPath)"

        urlComponents.queryItems = [
            URLQueryItem(name: "api_key", value: key)
        ]

        for (key, value) in parameters ?? [:] {
            urlComponents.queryItems?.append(URLQueryItem(name: key, value: value))
        }

        guard let url = urlComponents.url else {
            return nil
        }

        return URLSession.shared.dataTask(with: url, completionHandler: completionHandler)
    }
}
