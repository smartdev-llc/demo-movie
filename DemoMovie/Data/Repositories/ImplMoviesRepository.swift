//
//  ImplMoviesRepository.swift
//  DemoMovie
//
//  Created by Dat Bui on 16/03/2023.
//

import Foundation

final class ImplMoviesRepository: MoviesRepository {
    
    private let service: APIService
    
    public init(service: APIService) {
        self.service = service
    }
    
    func fetchMoviesList(query: String, completion: @escaping (Result<[Movie], Error>) -> Void) -> Cancellable? {
        let task = RepositoryTask()
        task.networkTask = service.request(with: APIEndpoint.getMovies(text: query), completion: { result in
            switch result {
            case .success(let responseDTO):
                completion(.success(responseDTO.search.toDomain()))
            case .failure(let error):
                completion(.failure(error))
            }
        })
        return task
    }
}
