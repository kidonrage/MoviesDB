//
//  MovieImagesService.swift
//  MoviesDB
//
//  Created by Vlad Eliseev on 14.05.2021.
//

import Foundation

final class MovieImagesService: MovieImagesServiceProtocol {
    // MARK: - Private Properties

    private let networkManager = NetworkManager()

    // MARK: - Public Methods

    func fetchImages(
        ofMovieWithId movieId: Int,
        _ completionHandler: @escaping (Result<[MoviePhoto], DataResponseError>) -> Void
    ) {
        networkManager.executeDecodableDataTask(
            withEndpointPath: getEndpointPath(forMovieWithId: movieId),
            parameters: nil
        ) { (result: Result<MoviePhotosResponse, DataResponseError>) in
            switch result {
            case let .success(response):
                completionHandler(.success(response.backdrops))
            case let .failure(error):
                completionHandler(.failure(error))
            }
        }
    }

    func fetchImageData(imagePath: String, _ completionHandler: @escaping (Result<Data, DataResponseError>) -> Void) {
        if let cachedImageData = getCachedImageData(imagePath: imagePath) {
            completionHandler(.success(cachedImageData))
            return
        }

        guard let url = getMovieImageURL(withPath: imagePath) else {
            return
        }

        networkManager.executeDataTask(with: url, parameters: nil) { [weak self] result in
            switch result {
            case let .success(data):
                self?.saveImageDataToCache(imagePath: imagePath, imageData: data)
                completionHandler(result)
            default:
                completionHandler(result)
            }
        }
    }

    // MARK: - Private Methods

    private func getCachedImageData(imagePath: String) -> Data? {
        guard
            let cachedImageURL = getImageCacheURL(imagePath: imagePath),
            let data = try? Data(contentsOf: cachedImageURL)
        else {
            return nil
        }

        return data
    }

    private func saveImageDataToCache(imagePath: String, imageData: Data) {
        guard let cachedImageURL = getImageCacheURL(imagePath: imagePath) else {
            return
        }

        FileManager.default.createFile(atPath: cachedImageURL.path, contents: imageData, attributes: nil)
    }

    private func getImageCacheURL(imagePath: String) -> URL? {
        guard let cacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first else {
            return nil
        }

        let fileName = String(describing: imagePath.hashValue)
        let cachedImageURL = cacheDirectory.appendingPathComponent(fileName).absoluteURL

        return cachedImageURL
    }

    private func getEndpointPath(forMovieWithId movieId: Int) -> String {
        "\(movieId)/images"
    }
}
