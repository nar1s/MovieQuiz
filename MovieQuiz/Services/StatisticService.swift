//
//  StatisticService.swift
//  MovieQuiz
//
//  Created by Павел Кузнецов on 27.08.2025.
//
import Foundation

final class StatisticService {
    private let storage: UserDefaults = .standard
    private enum Keys: String {
        case gamesCount          // Для счётчика сыгранных игр
        case bestGameCorrect     // Для количества правильных ответов в лучшей игре
        case bestGameTotal       // Для общего количества вопросов в лучшей игре
        case bestGameDate        // Для даты лучшей игры
        case totalCorrectAnswers // Для общего количества правильных ответов за все игры
        case totalQuestionsAsked // Для общего количества вопросов, заданных за все игры
    }
    
    private var totalCorrectAnswers: Int
    private var totalQuestionsAsked: Int

    init() {
        totalCorrectAnswers = storage.integer(forKey: Keys.totalCorrectAnswers.rawValue)
        totalQuestionsAsked = storage.integer(forKey: Keys.totalQuestionsAsked.rawValue)
    }
}

extension StatisticService: StatisticsServiceProtocol {
    var gamesCount: Int {
        get {
            storage.integer(forKey: Keys.gamesCount.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.gamesCount.rawValue)
        }
    }
    
    var bestGame: GameResult {
        get {
            let correct = storage.integer(forKey: Keys.bestGameCorrect.rawValue)
            let total = storage.integer(forKey: Keys.bestGameTotal.rawValue)
            let date = storage.object(forKey: Keys.bestGameDate.rawValue) as? Date ?? Date()
            return GameResult(correct: correct, total: total, date: date)
        }
        set {
            storage.set(newValue.correct, forKey: Keys.bestGameCorrect.rawValue)
            storage.set(newValue.total, forKey: Keys.bestGameTotal.rawValue)
            storage.set(Date(), forKey: Keys.bestGameDate.rawValue)
        }
    }
    
    var totalAccuracy: Double {
        guard totalQuestionsAsked > 0 else { return 0 }
        return(Double(totalCorrectAnswers)/Double(totalQuestionsAsked)*100)
    }

    func store(correct count: Int, total amount: Int) {
        gamesCount += 1
        if bestGame.correct < count {
            let newBestGame = GameResult(correct: count, total: amount, date: Date())
            bestGame = newBestGame
        }
        totalCorrectAnswers += count
        totalQuestionsAsked += amount
        storage.set(totalCorrectAnswers, forKey: Keys.totalCorrectAnswers.rawValue)
        storage.set(totalQuestionsAsked, forKey: Keys.totalQuestionsAsked.rawValue)
    }
}
