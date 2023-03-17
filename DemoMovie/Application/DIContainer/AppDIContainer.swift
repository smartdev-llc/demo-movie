//
//  AppDIContainer.swift
//  DemoMovie
//
//  Created by Dat Bui on 16/03/2023.
//

import Foundation

final class AppDIContainer {
    
    lazy var appConfiguration = AppConfiguration()
    
    // MARK: - Network
    lazy var apiService: APIService = {
        let config = ApiNetworkConfig(baseURL: URL(string: appConfiguration.apiBaseURL)!)
        
        let apiDataNetwork = ImplNetworkService(config: config)
        return ImplAPIService(with: apiDataNetwork)
    }()
    
    // MARK: - DIContainers of scenes
    func makeMovieSceneDIContainer() -> MovieDIContainer {
        let dependency = MovieDIContainer.Dependencies(apiService: apiService)
        return MovieDIContainer(dependency: dependency)
    }
}
