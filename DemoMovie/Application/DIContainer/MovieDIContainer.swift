//
//  MovieDIContainer.swift
//  DemoMovie
//
//  Created by Dat Bui on 16/03/2023.
//

import Foundation
import UIKit

final class MovieDIContainer {

    struct Dependencies {
        let apiService: APIService
    }
    
    private let dependency: Dependencies
    
    init(dependency: Dependencies) {
        self.dependency = dependency
    }
    
}

extension MovieDIContainer: MoviesFlowCoordinatorDependency {
    func makeMoviesViewController(viewModel: MoviesViewModel) -> MoviesViewController {
        MoviesViewController(viewModel: viewModel)
    }
    
    // MARK: Use Cases
    private func makeMoviesUseCase() -> FetchMoviesUseCase {
        ImplFetchMoviesUseCase(moviesRepository: makeMoviesRepo())
    }
    
    // MARK: Repository
    func makeMoviesRepo() -> MoviesRepository {
        ImplMoviesRepository(service: dependency.apiService)
    }
    
    // MARK: ViewModel
    func makeMoviesViewModel() -> MoviesViewModel {
        ImplMoviesViewModel(useCase: makeMoviesUseCase())
    }
    
    public func makeMovieCoordinator(navigationController: UINavigationController) -> MoviesCoordinator {
        MoviesCoordinator(navigationController: navigationController, dependency: self)
    }
}
