//
//  APIError.swift
//  Motiv
//
//  Created by William Little on 2024-01-16.
//

import Foundation

enum APIError: Error {
    case networkError(Error)
    case invalidResponse
    case decodingError(Error)
}
