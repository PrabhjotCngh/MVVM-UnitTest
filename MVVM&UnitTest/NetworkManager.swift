//
//  APIController.swift
//  MVVM&UnitTest
//
//  Created by M_2195552 on 2023-05-03.
//

import Foundation

protocol NetworkRequestProtocol {
    associatedtype Model
    associatedtype Err: Error
    typealias Handler = (Result<Model, Err>) -> Void
    func makeAPIRequest(completionHandler: @escaping Handler)
}

struct NetworkManager: NetworkRequestProtocol {
    typealias Model = SourcesModel
    typealias Err = Error
    private let session: URLSession
    
    // By using a default argument (in this case .shared) we can add dependency
    // injection without making our app code more complicated.
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    func makeAPIRequest(completionHandler: @escaping Handler) {
        guard let url = URL(string: APIConstants.apiUrl) else {
            completionHandler(.failure(NetworkError.badURL))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completionHandler(.failure(NetworkError.apiError(error)))
            }
            
            guard let data = data else {
                completionHandler(.failure(NetworkError.noData))
                return
            }
            
            do {
                let responseModel = try JSONDecoder().decode(SourcesModel.self, from: data)
                completionHandler(.success(responseModel))
            } catch {
                completionHandler(.failure(NetworkError.decodingError(error)))
            }
        }.resume()
    }
}
