//
//  MoviesRepository.swift
//  DemoMovie
//
//  Created by Dat Bui on 16/03/2023.
//

import Foundation

protocol MoviesRepository {
    func fetchMoviesList(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) -> Cancellable?
}
