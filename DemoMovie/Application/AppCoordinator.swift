//
//  AppCoordinator.swift
//  DemoMovie
//
//  Created by Dat Bui on 16/03/2023.
//

import Foundation
import UIKit

final class AppCoordinator {

    var navigationController: UINavigationController
    private let appDIContainer: AppDIContainer
    
    init(navigationController: UINavigationController, appDIContainer: AppDIContainer) {
        self.navigationController = navigationController
        self.appDIContainer = appDIContainer
    }

    func start() {
        let movieDIContainer = appDIContainer.makeMovieSceneDIContainer()
        let movieCoordinator = movieDIContainer.makeMovieCoordinator(navigationController: navigationController)
        movieCoordinator.start()
    }
}
