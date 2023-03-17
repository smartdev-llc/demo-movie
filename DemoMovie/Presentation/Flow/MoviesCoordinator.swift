//
//  MoviesCoordinator.swift
//  DemoMovie
//
//  Created by Dat Bui on 16/03/2023.
//

import Foundation
import UIKit

protocol MoviesFlowCoordinatorDependency  {
    func makeMoviesViewController(viewModel: MoviesViewModel) -> MoviesViewController
    func makeMoviesViewModel() -> MoviesViewModel
}

class MoviesCoordinator {
    
    private weak var navigationController: UINavigationController?
    private let dependency: MoviesFlowCoordinatorDependency

    init(navigationController: UINavigationController,
         dependency: MoviesFlowCoordinatorDependency) {
        self.navigationController = navigationController
        self.dependency = dependency
    }
    
    func start() {
        let vc = dependency.makeMoviesViewController(viewModel: dependency.makeMoviesViewModel())
        navigationController?.pushViewController(vc, animated: false)
    }
    
    func back() {
        navigationController?.popViewController(animated: true)
    }
}
