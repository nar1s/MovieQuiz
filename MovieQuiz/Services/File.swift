//
//  File.swift
//  MovieQuiz
//
//  Created by Павел Кузнецов on 21.09.2025.
//


    func removeHighlight() {
        imageView.layer.borderWidth = 0
    }
    
    func didLoadDataFromServer() {
        activityIndicator.isHidden = true
    }