//
//  MoviesDBUITests.swift
//  MoviesDBUITests
//
//  Created by Vlad Eliseev on 19.05.2021.
//

@testable import MoviesDB
import XCTest

final class MoviesDBUITests: XCTestCase {
    func testExample() throws {
        // UI tests must launch the application that they test.
        let app = XCUIApplication()
        app.launch()

        print(app.navigationBars["MoviesDB"].waitForExistence(timeout: 10))

        app.cells.allElementsBoundByIndex.first?.tap()
    }
}
