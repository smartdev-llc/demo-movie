//
//  FetchMoviesUseCase.swift
//  DemoMovie
//
//  Created by Dat Bui on 16/03/2023.
//

import Foundation

protocol FetchMoviesUseCase {
    @discardableResult
    func execute(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) -> Cancellable?
}

final class ImplFetchMoviesUseCase: FetchMoviesUseCase {
    
    private let moviesRepository: MoviesRepository
    
    public init(moviesRepository: MoviesRepository) {
        self.moviesRepository = moviesRepository
    }
    
    @discardableResult
    func execute(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) -> Cancellable? {
        moviesRepository.fetchMoviesList(query: query) { result in
            completion(result)
        }
    }
}
