//
//  MoviesLoader.swift
//  MovieQuiz
//
//  Created by Павел Кузнецов on 13.09.2025.
//

import Foundation

private enum Constants {
    static let top250MoviesURLString = "https://tv-api.com/en/API/Top250Movies/k_zcuw1ytf"
}

protocol MoviesLoadingProtocol {
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void)
}

struct MoviesLoader: MoviesLoadingProtocol {
    // MARK: - NetworkClient
    private let networkClient = NetworkClient()
    
    // MARK: - URL
    private var mostPopularMoviesUrl: URL {
            guard let url = URL(string: Constants.top250MoviesURLString) else {
                preconditionFailure("Unable to construct mostPopularMoviesUrl")
            }
            return url
        }
    
    func loadMovies(handler: @escaping (Result<MostPopularMovies, Error>) -> Void) {
        networkClient.fetch(url: mostPopularMoviesUrl) { result in
            switch result {
                case .success(let data):
                do {
                    let movies = try JSONDecoder().decode(MostPopularMovies.self, from: data)
                    handler(.success(movies))
                } catch {
                    handler(.failure(error))
                }
            case .failure(let error):
                handler(.failure(error))
            }
        }
    }
}
