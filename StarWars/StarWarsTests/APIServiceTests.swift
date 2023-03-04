//
//  APIServiceTests.swift
//  StarWarsTests
//
//  Created by Omar Hassanein on 04/03/2023.
//

import XCTest
@testable import StarWars

class APIServiceTests: XCTestCase {
    var sut: FilmServiceImplementation?
    override func setUp() {
        super.setUp()
        sut = FilmServiceImplementation()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_fetch_forecast() {

        // Given A apiservice
        let sut = self.sut!

        // When fetch popular photo
        let expect = XCTestExpectation(description: "callback")

        sut.getFilm{[weak self] result in
            guard let self = self else {
                return
            }
            expect.fulfill()
            switch result {
            case .success(let data):
                XCTAssertGreaterThan(data.results.count, 2)
            case .failure(let error):
                XCTAssertNotNil(error)
            }
            self.wait(for: [expect], timeout: 3.1)
    }
}
}
