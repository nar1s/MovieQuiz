//
//  QuestionFactoryProtocol.swift
//  MovieQuiz
//
//  Created by Павел Кузнецов on 26.08.2025.
//

protocol QuestionFactoryProtocol {
    func requestNextQuestion()
    func setup(delegate: QuestionFactoryDelegate)
    func reset()
}
