//
//  AlertDisplayer.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 13.05.2021.
//

import UIKit

protocol AlertDisplayer {
    func displayAlert(title: String?, message: String?, actions: [UIAlertAction]?)
}

extension AlertDisplayer where Self: UIViewController {
    func displayAlert(title: String?, message: String?, actions: [UIAlertAction]?) {
        guard presentedViewController == nil else {
            return
        }

        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)

        actions?.forEach { action in
            alertController.addAction(action)
        }

        present(alertController, animated: true, completion: nil)
    }
}
