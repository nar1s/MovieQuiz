//
//  QuestionFactoryDelegate.swift
//  MovieQuiz
//
//  Created by Павел Кузнецов on 27.08.2025.
//

protocol QuestionFactoryDelegate: AnyObject {
    func didReceiveNextQuestion(question: QuizQuestion?)
}
