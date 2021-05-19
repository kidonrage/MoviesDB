//
//  MovieImagesServiceMock.swift
//  MVVMMoviesTests
//
//  Created by Vlad Eliseev on 19.05.2021.
//

import Foundation
@testable import MVVMMovies

final class MovieImagesServiceMock: MovieImagesServiceProtocol {
    func fetchImages(
        ofMovieWithId movieId: Int,
        _ completionHandler: @escaping (Result<[MoviePhoto], DataResponseError>) -> Void
    ) {
        completionHandler(.success([MoviePhoto(aspectRatio: 0.5, filePath: "/test.jpg")]))
    }

    func fetchImageData(imagePath: String, _ completionHandler: @escaping (Result<Data, DataResponseError>) -> Void) {
        completionHandler(.success(Data(count: 0)))
    }
}
