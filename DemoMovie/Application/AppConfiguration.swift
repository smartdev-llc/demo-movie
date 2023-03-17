//
//  AppConfiguration.swift
//  DemoMovie
//
//  Created by Dat Bui on 16/03/2023.
//

import Foundation

final class AppConfiguration {
    lazy var apiBaseURL: String = {
        return "http://www.omdbapi.com"
    }()
}
