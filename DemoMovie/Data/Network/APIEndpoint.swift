//
//  APIEndpoint.swift
//  DemoMovie
//
//  Created by Dat Bui on 16/03/2023.
//

import Foundation

struct APIEndpoint {
    static func getMovies(text: String) -> Endpoint<MoviesResponse> {
        let param: [String:String] = ["apikey":"b9bd48a6",
                                     "type":"movie",
                                     "s":text]
        return Endpoint(path: "", method: .get, queryParameters: param)
    }
}
