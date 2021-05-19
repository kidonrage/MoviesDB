//
//  MoviesDBTests.swift
//  MoviesDBTests
//
//  Created by Vlad Eliseev on 19.05.2021.
//

@testable import MoviesDB
import XCTest

final class MoviesDBTests: XCTestCase {
    private var moviesManager: MoviesManagerProtocol!
    private var moviesListViewModel: MoviesListViewModelProtocol!

    override func setUp() {
        moviesManager = MoviesManagerMock()
        moviesListViewModel = MoviesListViewModel(moviesManager: moviesManager)
    }

    override func tearDown() {
        moviesManager = nil
        moviesListViewModel = nil
    }

    func testFetchingMovies() {
        moviesListViewModel.fetchMovies()

        XCTAssertEqual(moviesListViewModel.currentCount, 10)

        moviesListViewModel.fetchMovies()

        XCTAssertEqual(moviesListViewModel.currentCount, 20)
    }

    func testRefreshingMovies() {
        moviesListViewModel.fetchMovies()
        moviesListViewModel.fetchMovies()
        moviesListViewModel.refreshMovies()

        XCTAssertEqual(moviesListViewModel.currentCount, 10)
    }
}
