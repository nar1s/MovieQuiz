//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Павел Кузнецов on 26.08.2025.
//

import Foundation

final class QuestionFactory: QuestionFactoryProtocol {
    private let questions: [QuizQuestion] =
    [QuizQuestion(image: "The Godfather", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
     QuizQuestion(image: "The Dark Knight", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
     QuizQuestion(image: "Kill Bill", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
     QuizQuestion(image: "The Avengers", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
     QuizQuestion(image: "Deadpool", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
     QuizQuestion(image: "The Green Knight", text: "Рейтинг этого фильма больше 6?", correctAnswer: true),
     QuizQuestion(image: "Old", text: "Рейтинг этого фильма больше 6?", correctAnswer: false),
     QuizQuestion(image: "The Ice Age Adventures of Buck Wild", text: "Рейтинг этого фильма больше 6?", correctAnswer: false),
     QuizQuestion(image: "Tesla", text: "Рейтинг этого фильма больше 6?", correctAnswer: false),
     QuizQuestion(image: "Vivarium", text: "Рейтинг этого фильма больше 6?", correctAnswer: false)]
    
    private var usedIndexes: Set<Int> = []
    
    weak var delegate: QuestionFactoryDelegate?
    
    func setup(delegate: QuestionFactoryDelegate) {
        self.delegate = delegate
    }
    
    func requestNextQuestion() {
        let availableIndexes = Array(0..<questions.count).filter {
            !usedIndexes.contains($0)
        }
        
        guard let index = availableIndexes.randomElement() else {
            delegate?.didReceiveNextQuestion(question: nil)
            return
        }
        
        usedIndexes.insert(index)
        let question = questions[safe: index]
        delegate?.didReceiveNextQuestion(question: question)
    }

    func reset() {
        usedIndexes.removeAll()
    }
}
