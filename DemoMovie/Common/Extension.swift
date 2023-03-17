//
//  Extension.swift
//  DemoMovie
//
//  Created by Dat Bui on 16/03/2023.
//

import Foundation

extension Collection where Element == MovieDTO {
    func toDomain() -> [Movie] {
        self.map { $0.toDomain() }
    }
}

extension NSObject {
    static var identifier: String {
        return String(describing: Self.self)
    }
}

extension String {
    static func rounded(value: Double) -> Self {
        String(format: "%.2f", value)
    }
}
