//
//  QuestionFactory.swift
//  MovieQuiz
//
//  Created by Павел Кузнецов on 26.08.2025.
//

import Foundation

private enum Constants {
    static let maxRating: Int = 9
    static let ratingDelta: Int = 1
}

final class QuestionFactory: QuestionFactoryProtocol {
    private var moviesLoader: MoviesLoadingProtocol
    private weak var delegate: QuestionFactoryDelegate?
    private var movies: [MostPopularMovie] = []
    
    init(moviesLoader: MoviesLoadingProtocol, delegate: QuestionFactoryDelegate) {
        self.moviesLoader = moviesLoader
        self.delegate = delegate
    }
    
    func loadData() {
        moviesLoader.loadMovies { [weak self] result in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let mostPopularMovies):
                    self.movies = mostPopularMovies.items
                    self.delegate?.didLoadDataFromServer()
                case .failure(let error):
                    self.delegate?.didFailToLoadData(with: error)
                }
            }
        }
    }
    
    func requestNextQuestion() {
        DispatchQueue.global().async { [weak self] in
            guard let self = self else { return }
            
            let index = (0..<self.movies.count).randomElement() ?? 0
            
            guard let movie = self.movies[safe: index] else { return }
            
            var imageData = Data()
            
            do {
                imageData = try Data(contentsOf: movie.resizedImageURL)
            } catch {
                print("Failed to load image")
            }
               
            let rating = Float(movie.rating) ?? 0
            var ratingsAsked: [Int] = []
            if Int(rating) < Constants.maxRating {
                ratingsAsked = [Int(rating) - Constants.ratingDelta,
                                Int(rating),
                                Int(rating) + Constants.ratingDelta]
            } else if Int(rating) == Constants.maxRating {
                ratingsAsked = [Int(rating) - Constants.ratingDelta, Int(rating)]
            }
            
            let ratingQuestion = ratingsAsked.randomElement() ?? 0
            
            let askMore = Bool.random()
            
            let text: String
            let correctAnswer: Bool
            
            if askMore {
                text = "Рейтинг этого фильма больше чем \(ratingQuestion)?"
                correctAnswer = rating > Float(ratingQuestion)
            } else {
                text = "Рейтинг этого фильма меньше чем \(ratingQuestion)?"
                correctAnswer = rating < Float(ratingQuestion)
            }
               
            let question = QuizQuestion(image: imageData,
                                        text: text,
                                        correctAnswer: correctAnswer)
               
            DispatchQueue.main.async { [weak self] in
                guard let self = self else { return }
                self.delegate?.didReceiveNextQuestion(question: question)
            }
        }
    }
}
