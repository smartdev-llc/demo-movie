//
//  ResponseDecoder.swift
//  DemoMovie
//
//  Created by Dat Bui on 16/03/2023.
//

import Foundation
public protocol ResponseDecoder {
    func decode<T: Decodable>(_ data: Data) throws -> T
}
