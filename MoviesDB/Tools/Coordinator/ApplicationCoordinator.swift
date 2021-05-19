//
//  ApplicationCoordinator.swift
//  MoviesDB
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
        let networkManager = NetworkManager()
        let databaseManager = CoreDataStack()
        let moviesManager = MoviesManager(networkManager: networkManager, databaseManager: databaseManager)
        let viewModel = MoviesListViewModel(moviesManager: moviesManager)
        let controller = MoviesListViewController(viewModel: viewModel)

        controller.handleGoingToMovieDetails = { [weak self] movie in
            self?.showMovieDetails(for: movie)
        }

        let rootController = UINavigationController(rootViewController: controller)
        setAsRoot(rootController)
        rootController.navigationBar.accessibilityLabel = "MoviesDB"
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
