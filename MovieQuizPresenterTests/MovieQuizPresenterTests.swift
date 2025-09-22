//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Павел Кузнецов on 21.09.2025.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    var lastShownStep: QuizStepViewModel?
    
    func show(quiz step: QuizStepViewModel) {
        lastShownStep = step
    }
    
    func show(quiz result: QuizResultViewModel) {}
    func highlightAnswer(isCorrect: Bool) {}
    func removeHighlight() {}
    func didLoadDataFromServer() {}
    func didFailToLoadData(with error: Error){}
}

final class MovieQuizPresenterTests: XCTestCase {
    var viewControllerMock: MovieQuizViewControllerMock!
    var presenter: MovieQuizPresenter!

    override func setUpWithError() throws {
        viewControllerMock = MovieQuizViewControllerMock()
        presenter = MovieQuizPresenter(
            viewController: viewControllerMock,
            statisticsService: StatisticService()
        )
    }

    override func tearDownWithError() throws {
        viewControllerMock = nil
        presenter = nil
    }

    func testConvertModelToViewModel() {
        // Given
        let imageData = "test".data(using: .utf8)!
        let question = QuizQuestion(image: imageData, text: "Is this a test?", correctAnswer: true)

        // When
        let viewModel = presenter.convert(model: question)

        // Then
        XCTAssertEqual(viewModel.question, "Is this a test?")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
        XCTAssertNotNil(viewModel.image)
    }

    func testShowQuizStepCallsViewController() {
        // Given
        let imageData = Data()
        let question = QuizQuestion(image: imageData, text: "Sample", correctAnswer: false)

        // When
        let viewModel = presenter.convert(model: question)
        viewControllerMock.show(quiz: viewModel)

        // Then
        XCTAssertEqual(viewControllerMock.lastShownStep?.question, "Sample")
        XCTAssertEqual(viewControllerMock.lastShownStep?.questionNumber, "1/10")
        XCTAssertNotNil(viewControllerMock.lastShownStep?.image)
    }
}
