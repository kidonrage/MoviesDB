//
//  RemoteImageView.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 12.03.2021.
//

import UIKit

final class RemoteImageView: UIImageView {
    // MARK: - Private Properties

    private var currentTask: URLSessionDataTask?

    // MARK: - Public Methods

    func loadImageFromUrl(url: URL) {
        image = nil

        currentTask?.cancel()

        currentTask = URLSession.shared.dataTask(with: url) { data, _, _ in
            guard let data = data, let newImage = UIImage(data: data) else {
                return
            }

            DispatchQueue.main.async {
                self.image = newImage
            }
        }

        currentTask?.resume()
    }
}
