//
//  StatisticsServiceProtocol.swift
//  MovieQuiz
//
//  Created by Павел Кузнецов on 27.08.2025.
//

protocol StatisticsServiceProtocol {
    var gamesCount: Int { get }
    var bestGame: GameResult { get }
    var totalAccuracy: Double { get }
    
    func store(correct count: Int, total amount: Int)
}
