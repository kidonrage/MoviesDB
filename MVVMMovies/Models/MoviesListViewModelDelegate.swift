//
//  MVVMMoviesListViewModelDelegate.swift
//  MVVMMovies
//
//  Created by Vlad Eliseev on 12.03.2021.
//

import Foundation

protocol MVVMMoviesListViewModelDelegate: AnyObject {
    func didFetchMVVMMovies(with newIndexPathsToReload: [IndexPath]?)
    func didFetchPlayingMVVMMovies()
    func didFailedFetchingMVVMMovies()
}
