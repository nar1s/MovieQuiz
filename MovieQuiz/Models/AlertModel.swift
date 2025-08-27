//
//  AlertModel.swift
//  MovieQuiz
//
//  Created by Павел Кузнецов on 27.08.2025.
//

struct AlertModel {
    var title: String
    var message: String
    var buttonTitle: String
    var completion: () -> Void
}
