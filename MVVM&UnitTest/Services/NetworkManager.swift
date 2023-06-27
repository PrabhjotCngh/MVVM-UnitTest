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
    typealias Err = NetworkError
    private let session: URLSession
    
    // By using a default argument (in this case .shared) we can add dependency
    // injection without making our app code more complicated.
    init(session: URLSession = .shared) {
        self.session = session
    }
    
    //MARK: - Completion handler method implementation
    func makeAPIRequest(completionHandler: @escaping Handler) {
        guard let url = URL(string: APIConstants.apiUrl) else {
            completionHandler(.failure(.invalidURL))
            return
        }
        
        let urlRequest = URLRequest(url: url)
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completionHandler(.failure(.apiError(error)))
            }
            
            guard let data = data else {
                completionHandler(.failure(.invalidData))
                return
            }
            
            guard let response = response as? HTTPURLResponse,
                  200 ... 299 ~= response.statusCode else {
                completionHandler(.failure(.invalidResponse))
                return
            }
            
            do {
                let responseModel = try JSONDecoder().decode(SourcesModel.self, from: data)
                completionHandler(.success(responseModel))
            } catch {
                completionHandler(.failure(.decodingError(error)))
            }
        }.resume()
    }
    
    //MARK: - async/await method implementation
    func request(url: String) async throws -> Result<Model, NetworkError> {
        guard let url = URL(string: APIConstants.apiUrl) else {
            throw NetworkError.invalidURL
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard (response as? HTTPURLResponse)?.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let responseModel = try JSONDecoder().decode(SourcesModel.self, from: data)
            return .success(responseModel)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
