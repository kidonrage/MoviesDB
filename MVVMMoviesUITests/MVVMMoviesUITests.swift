//
//  MVVMMoviesUITests.swift
//  MVVMMoviesUITests
//
//  Created by Vlad Eliseev on 19.05.2021.
//

@testable import MVVMMovies
import XCTest

final class MVVMMoviesUITests: XCTestCase {
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        print(app.navigationBars["MVVMMovies"].waitForExistence(timeout: 10))

        app.cells.allElementsBoundByIndex.first?.tap()
    }
}
