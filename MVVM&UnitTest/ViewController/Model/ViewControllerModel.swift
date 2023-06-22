//
//  ViewControllerModel.swift
//  MVVM&UnitTest
//
//  Created by M_2195552 on 2023-05-03.
//

import Foundation

struct SourcesModel: Codable {
    let sources: [APIResponseModel]
}

struct APIResponseModel: Codable {
    let name: String
    let description: String
    let url: String
}
