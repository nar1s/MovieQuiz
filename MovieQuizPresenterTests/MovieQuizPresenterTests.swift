//
//  MovieQuizPresenterTests.swift
//  MovieQuizPresenterTests
//
//  Created by Павел Кузнецов on 21.09.2025.
//

import XCTest
@testable import MovieQuiz

final class MovieQuizViewControllerMock: MovieQuizViewControllerProtocol {
    func show(quiz step: QuizStepViewModel) {}
    func show(quiz result: QuizResultViewModel) {}
    func highlightAnswer(isCorrect: Bool) {}
    func removeHighlight() {}
    func didLoadDataFromServer() {}
    func didFailToLoadData(with error: Error){}
}

final class MovieQuizPresenterTests: XCTestCase {
    func testPresenterConvertModel() throws {
        let viewControllerMock = MovieQuizViewControllerMock()
        let sut = MovieQuizPresenter(
            viewController: viewControllerMock,
            statisticsService: StatisticService()
        )
        
        let emptyData = Data()
        let question = QuizQuestion(image: emptyData, text: "Question Text", correctAnswer: true)
        let viewModel = sut.convert(model: question)
        
        XCTAssertNotNil(viewModel.image)
        XCTAssertEqual(viewModel.question, "Question Text")
        XCTAssertEqual(viewModel.questionNumber, "1/10")
    }
}
