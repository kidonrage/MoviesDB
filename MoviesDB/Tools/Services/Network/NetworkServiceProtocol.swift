//
//  NetworkServiceProtocol.swift
//  MoviesDB
//
//  Created by Vlad Eliseev on 17.05.2021.
//

import Foundation

protocol NetworkServiceProtocol {
    @discardableResult
    func executeDecodableDataTask<T: Decodable>(
        withEndpointPath endpointPath: String,
        parameters: [String: String]?,
        _ callback: @escaping (Result<T, DataResponseError>) -> Void
    ) -> URLSessionDataTask?

    @discardableResult
    func executeDataTask(
        with url: URL,
        parameters: [String: String]?,
        _ callback: @escaping (Result<Data, DataResponseError>) -> Void
    ) -> URLSessionDataTask
}
