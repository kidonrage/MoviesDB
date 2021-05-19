//
//  MoviesManagerMock.swift
//  MVVMMoviesTests
//
//  Created by Vlad Eliseev on 19.05.2021.
//

import Foundation
@testable import MVVMMovies

final class MoviesManagerMock: MoviesManagerProtocol {
    // MARK: - Public Properties

    var moviesFetchResultsCount = 10

    func getCachedMovies(ofType type: MoviesListType) -> [Movie] {
        []
    }

    func fetchMovies(
        ofType type: MoviesListType,
        page: Int,
        _ completionHandler: @escaping (Result<MoviesQueryResponse, DataResponseError>) -> Void
    ) -> URLSessionDataTask? {
        var mockedResults: [Movie] = []

        for index in 0 ..< moviesFetchResultsCount {
            mockedResults.append(Movie(
                id: index * page,
                title: "Title",
                posterPath: nil,
                releaseDate: "10-05-2021",
                overview: "Overview",
                type: type
            ))
        }

        let mockedResponse = MoviesQueryResponse(results: mockedResults, page: page, totalResults: 30)

        completionHandler(.success(mockedResponse))

        return nil
    }
}
