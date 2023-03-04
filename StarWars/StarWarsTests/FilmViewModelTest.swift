//
//  FilmViewModelTest.swift
//  StarWarsTests
//
//  Created by Omar Hassanein on 04/03/2023.
//

import XCTest
@testable import StarWars

class FilmViewModelTest: XCTestCase {
    var sut: FilmViewModelLogic!
    var apiServiceMock: ApiServiceMock!

    override func setUp() {
        super.setUp()
        apiServiceMock = ApiServiceMock()
        sut = FilmViewModel(apiService: apiServiceMock)
    }
    override func tearDown() {
        sut = nil
        apiServiceMock = nil
        super.tearDown()
    }
    func test_fetch_forecast() {
        // Given
        apiServiceMock.completeData = [FilmData]()

        // When
        sut.getFilms()

        // Assert
        XCTAssert(apiServiceMock!.isFetchDataCalled)
    }
    func test_loading_state_when_fetching() {
        // Given
        var state: State = .empty
        let expect = XCTestExpectation(description: "Loading state updated to populated")
        sut.updateLoadingStatus = {
            state = self.sut!.state
            expect.fulfill()
        }
        // when fetching
        sut.getFilms()
        // Assert
        XCTAssertEqual(state, State.loading)
        wait(for: [expect], timeout: 1.0)
    }
}
