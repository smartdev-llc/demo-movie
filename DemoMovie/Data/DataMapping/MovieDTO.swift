//
//  MovieDTO.swift
//  DemoMovie
//
//  Created by Dat Bui on 16/03/2023.
//

import Foundation

struct MovieDTO: Decodable {
    
    let title: String
    let year: String
    let imdbID: String
    let type: String
    let poster: String
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case year = "Year"
        case imdbID
        case type = "Type"
        case poster = "Poster"
    }
}

extension MovieDTO {
    func toDomain() -> Movie {
        Movie(title: title, year: year, imdbID: imdbID, type: type, poster: poster)
    }
}
