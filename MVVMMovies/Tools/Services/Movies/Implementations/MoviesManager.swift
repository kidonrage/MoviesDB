//
//  MoviesManager.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 05.03.2021.
//

import CoreData
import Foundation

final class MoviesManager: MoviesManagerProtocol {
    // MARK: - Private Properties

    private let networkManager: NetworkServiceProtocol
    private let databaseManager: DatabaseServiceProtocol

    // MARK: - Initializers

    init(networkManager: NetworkServiceProtocol, databaseManager: DatabaseServiceProtocol) {
        self.networkManager = networkManager
        self.databaseManager = databaseManager
    }

    // MARK: - Public Methods

    func getCachedMovies(
        ofType type: MoviesListType
    ) -> [Movie] {
        let request: NSFetchRequest<DBMovie> = DBMovie.fetchRequest()
        request.predicate = NSPredicate(format: "type == %d", Int16(type.rawValue))

        let results = databaseManager.executeFetchRequest(request)

        return (results ?? []).compactMap { Movie(dbMovie: $0) }
    }

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
        ]) { [weak self] (result: Result<MoviesQueryResponse, DataResponseError>) in
            switch result {
            case let .success(response):
                let movies = response.results.map { movie -> Movie in
                    var result = movie
                    result.type = type
                    return result
                }

                self?.saveMoviesToDB(movies)

                completionHandler(result)
            default:
                completionHandler(result)
            }
        }
    }

    private func saveMoviesToDB(_ movies: [Movie]) {
        databaseManager.performSave { context in
            movies.forEach { movie in
                let movieToSave = DBMovie(context: context)
                movieToSave.id = Int64(movie.id)
                movieToSave.title = movie.title
                movieToSave.overview = movie.overview
                movieToSave.posterPath = movie.posterPath
                movieToSave.releaseDate = movie.releaseDate
                movieToSave.type = Int16(movie.type?.rawValue ?? 0)
            }
        }
    }
}
