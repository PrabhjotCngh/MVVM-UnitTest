//
//  ViewControllerViewModel.swift
//  MVVM&UnitTest
//
//  Created by M_2195552 on 2023-05-03.
//

import Foundation

class ViewControllerViewModel {
    
    var requestSucceeded: () -> Void = {}
    var requestFailed: (String) -> Void = {_ in}
    var apiResponseModel = [APIResponseModel]()
    
    var numberOfRows: Int {
        return apiResponseModel.count
    }
    
    func getData() {
        NetworkManager().makeAPIRequest { [weak self] result in
            if let _weakSelf = self {
                switch result {
                case .success(let response):
                    _weakSelf.apiResponseModel = response.sources
                    _weakSelf.requestSucceeded()
                case .failure(NetworkError.invalidURL):
                    _weakSelf.requestFailed("Incorrect url!")
                case .failure(NetworkError.invalidData):
                    _weakSelf.requestFailed("Response data is empty!")
                case .failure(NetworkError.decodingError(let error)), .failure(NetworkError.apiError(let error)):
                    _weakSelf.requestFailed(error.localizedDescription)
                default:
                    _weakSelf.requestFailed("Something went wrong! Please try again later.")
                }
            }
        }
    }
    
}
