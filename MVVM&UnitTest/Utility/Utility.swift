//
//  Utility.swift
//  MVVM&UnitTest
//
//  Created by M_2195552 on 2023-05-03.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidData
    case invalidResponse
    case decodingError(Error)
    case apiError(Error)
}

enum APIConstants {
    static let apiUrl = "https://newsapi.org/v2/sources?apiKey=0cf790498275413a9247f8b94b3843fd"
}

enum ViewControllerConstants {
    static let tableViewCellId = "cellIdentifier"
}
