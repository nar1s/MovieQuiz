//
//  MovieQuizViewControllerProtocol.swift
//  MovieQuiz
//
//  Created by Павел Кузнецов on 27.08.2025.
//

protocol MovieQuizViewControllerProtocol: AnyObject {
    func show(quiz step: QuizStepViewModel)
    func show(quiz result: QuizResultViewModel)
    func highlightAnswer(isCorrect: Bool)
    func removeHighlight()
}
