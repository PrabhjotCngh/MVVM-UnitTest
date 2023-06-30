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
    var apiResponseModel: [APIResponseModel] = [] {
        didSet {
            requestSucceeded()
        }
    }
    private let manager = NetworkManager()

    var numberOfRows: Int {
        return apiResponseModel.count
    }
    
    //MARK: - Completion handler method implementation
    func getData() {
        manager.makeAPIRequest { [weak self] result in
            if let _weakSelf = self {
                switch result {
                case .success(let response):
                    _weakSelf.apiResponseModel = response.sources
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
    
    //MARK: - async/await method implementation
    /// @MainActor -> DispatchQueue.main.async
    @MainActor func fetchData() {
        Task {
            do {
                let result = try await manager.request()
                switch result {
                case .success(let response):
                    apiResponseModel = response.sources
                case .failure(NetworkError.invalidURL):
                    requestFailed("Incorrect url!")
                case .failure(NetworkError.invalidData):
                    requestFailed("Response data is empty!")
                case .failure(NetworkError.decodingError(let error)), .failure(NetworkError.apiError(let error)):
                    requestFailed(error.localizedDescription)
                default:
                    requestFailed("Something went wrong! Please try again later.")
                }
            } catch {
                requestFailed(error.localizedDescription)
            }
        }
    }
    
}
