//
//  BaseCoordinator.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 13.05.2021.
//

import UIKit

/// Абстрактный класс-координатор
class BaseCoordinator {
    var childCoordinators: [BaseCoordinator] = []

    func start() {}

    func addDependency(_ coordinator: BaseCoordinator) {
        for element in childCoordinators where element === coordinator {
            return
        }

        childCoordinators.append(coordinator)
    }

    func removeDependency(_ coordinator: BaseCoordinator?) {
        guard
            childCoordinators.isEmpty == false,
            let coordinator = coordinator
        else {
            return
        }

        for (index, element) in childCoordinators.reversed().enumerated() where element === coordinator {
            childCoordinators.remove(at: index)
            break
        }
    }

    func setAsRoot(_ controller: UIViewController) {
        UIApplication.shared.windows.first { $0.isKeyWindow }?.rootViewController = controller
    }
}
