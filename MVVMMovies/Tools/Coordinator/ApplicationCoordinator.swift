//
//  ApplicationCoordinator.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 13.05.2021.
//

import UIKit

final class ApplicationCoordinator: BaseCoordinator {
    private var rootController: UINavigationController?

    override func start() {
        showMoviesList()
    }

    private func showMoviesList() {
        let controller = MoviesListViewController(viewModel: MoviesListViewModel(moviesManager: MoviesManager()))

        controller.handleGoingToMovieDetails = { [weak self] movie in
            self?.showMovieDetails(for: movie)
        }

        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        self.rootController = rootController
    }

    private func showMovieDetails(for movie: Movie) {
        let viewModel = MovieDetailViewModel(
            movie: movie,
            movieImagesService: MovieImagesService()
        )
        let controller = MovieDetailsViewController(viewModel: viewModel)
        rootController?.pushViewController(controller, animated: true)
    }
}
