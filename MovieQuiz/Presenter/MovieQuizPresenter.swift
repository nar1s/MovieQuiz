//
//  MovieQuizPresenter.swift
//  MovieQuiz
//
//  Created by Павел Кузнецов on 27.08.2025.
//
import UIKit

final class MovieQuizPresenter {
    private weak var viewController: MovieQuizViewControllerProtocol?
    private let questionFactory: QuestionFactoryProtocol
    private let statisticsService: StatisticsServiceProtocol
    
    private var currentQuestion: QuizQuestion?
    private var currentQuestionIndex: Int = 0
    private var correctAnswersCount: Int = 0
    private let questionsAmount: Int = 10
    
    init(viewController: MovieQuizViewControllerProtocol,
         questionFactory: QuestionFactoryProtocol,
         statisticsService: StatisticsServiceProtocol) {
        self.viewController = viewController
        self.questionFactory = questionFactory
        self.statisticsService = statisticsService
    }
    
    // MARK: - Private methods
    
    private func answerGiven(_ answer: Bool) {
        guard let currentQuestion else { return }
        let isCorrect = (answer == currentQuestion.correctAnswer)
        correctAnswersCount += isCorrect ? 1 : 0
        
        viewController?.highlightAnswer(isCorrect: isCorrect)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { [weak self] in
            self?.viewController?.removeHighlight()
            self?.proceedToNextStep()
        }
    }
    
    private func proceedToNextStep() {
        if currentQuestionIndex == questionsAmount - 1 {
            statisticsService.store(correct: correctAnswersCount, total: questionsAmount)
            let result = QuizResultViewModel(
                title: "Этот раунд окончен!",
                text: makeResultMessage(),
                buttonText: "Сыграть ещё раз"
            )
            viewController?.show(quiz: result)
            questionFactory.reset()
        } else {
            currentQuestionIndex += 1
            questionFactory.requestNextQuestion()
        }
    }
    
    private func convert(model: QuizQuestion) -> QuizStepViewModel {
        QuizStepViewModel(image: UIImage(named: model.image) ?? UIImage(),
                          question: model.text,
                          questionNumber: "\(currentQuestionIndex + 1)/\(questionsAmount)")
    }
    
    // MARK: - Public methods
    
    func startGame() {
        questionFactory.setup(delegate: self)
        questionFactory.requestNextQuestion()
    }
    
    func restartGame() {
        currentQuestionIndex = 0
        correctAnswersCount = 0
        questionFactory.requestNextQuestion()
    }
    
    func makeResultMessage() -> String {
        return """
Ваш результат: \(correctAnswersCount)/\(questionsAmount)
Количество сыгранных квизов: \(statisticsService.gamesCount)
Рекорд: \(statisticsService.bestGame.correct)/\(statisticsService.bestGame.total) (\(statisticsService.bestGame.date.dateTimeString))
Средняя точность: \(String(format: "%.2f", statisticsService.totalAccuracy))%
"""
    }
    
    func didReceiveNextQuestion(_ question: QuizQuestion?) {
        guard let question else { return }
        currentQuestion = question
        let viewModel = convert(model: question)
        viewController?.show(quiz: viewModel)
    }
    
    func yesButtonClicked() {
        answerGiven(true)
    }
    
    func noButtonClicked() {
        answerGiven(false)
    }
}

// MARK: - QuestionFactoryDelegate

extension MovieQuizPresenter: QuestionFactoryDelegate {
    func didReceiveNextQuestion(question: QuizQuestion?) {
        didReceiveNextQuestion(question)
    }
}
