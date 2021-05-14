//
//  MovieImagesServiceProtocol.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 14.05.2021.
//

import Foundation

protocol MovieImagesServiceProtocol {
    func getMovieImageURL(withPath posterPath: String) -> URL?
    func fetchImages(
        ofMovieWithId movieId: Int,
        _ completionHandler: @escaping (Result<[MoviePhoto], DataResponseError>) -> Void
    )
    func fetchImageData(
        imagePath: String,
        _ completionHandler: @escaping (Result<Data, DataResponseError>) -> Void
    )
}
