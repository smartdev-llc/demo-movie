//
//  MoviesResponse.swift
//  DemoMovie
//
//  Created by Dat Bui on 16/03/2023.
//

import Foundation

struct MoviesResponse: Decodable {
    let search: [MovieDTO]
    
    enum CodingKeys: String, CodingKey {
        case search = "Search"
    }
}
