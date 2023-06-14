//
//  MVVM_UnitTestTests.swift
//  MVVM&UnitTestTests
//
//  Created by M_2195552 on 2023-05-03.
//

import XCTest
@testable import MVVM_UnitTest

final class MVVM_UnitTestTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func test_JsonStub_Success() throws {
        // Setup
        let data = try loadStub(name: "APIResponse", fileExtension: "json")
        // Act
        let response = try JSONDecoder().decode(SourcesModel.self, from: data)
        // Verify
        XCTAssertNotNil(response, "Response decoded successfully")
    }
    
    func test_JsonStub_Fail() throws {
        // Setup
        let data = try loadStub(name: "", fileExtension: "json")
        // Act
        let response = try JSONDecoder().decode(SourcesModel.self, from: data)
        // Verify
        XCTAssertNil(response, "Response decoding failed")
    }
    
    func test_Model_Success() throws {
        // Setup
        let name = "Name1"
        let description = "description details"
        let url = "test.com"
        // Act
        let responseModel = APIResponseModel(name: name, description: description, url: url)
        // Verify
        XCTAssertNotNil(responseModel, "Model created successfully")
    }
    
    func test_Model_Fail() throws {
        // Setup
        let name = "Name1"
        let description = ""
        let url = "test.com"
        // Act
        let responseModel = APIResponseModel(name: name, description: description, url: url)
        // Verify
        XCTAssertNil(responseModel, "Model not created")
    }
    
    func test_BasicRequest_Success() throws {
        // Setup
        let url = URL(string: APIConstants.apiUrl)
        // Act
        let urlRequest = URLRequest(url: try XCTUnwrap(url))
        // Verify
        XCTAssertEqual(urlRequest.url, try expectedUrl(), "Actual and expected URL's should be equal!")
    }

    func testSuccessfulResponse() {
        // Setup our objects
        let session = URLSessionMock()
        let manager = NetworkManager(session: session)
        
        // Create data and tell the session to always return it
        let data = Data([0, 1, 0, 1])
        session.data = data
        
        var result: Result<SourcesModel, Error>?
        manager.makeAPIRequest() { response in
            result = response
        }
        //XCTAssertEqual(result, data)

    }
    
//    func test_Example() throws {
//        let exp = expectation(description: "ok")
//        URLSession.shared.dataTask(with: URLRequest(url: try expectedUrl())) { data, _, error in
//            XCTAssertNil(error)
//            guard let data = data,
//                let text = String(data: data, encoding: .utf8) else {
//                XCTFail("invalid response body")
//                return
//            }
//            XCTAssertEqual(text, "Hello, world!")
//            exp.fulfill()
//        }.resume()
//        self.wait(for: [exp], timeout: 10.0)
//    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}

extension MVVM_UnitTestTests {
    func expectedUrl() throws -> URL {
        let url = URL(string: APIConstants.apiUrl)
        return try XCTUnwrap(url)
    }
    
    func loadStub(name: String, fileExtension: String) throws -> Data {
        // Obtain Reference to Bundle
        let bundle = Bundle(for: type(of: self))
        // Ask Bundle for URL of Stub
        let url = bundle.url(forResource: name, withExtension: fileExtension)
        // Use URL to Create Data Object
        return try Data(contentsOf: XCTUnwrap(url))
    }
}

// We create a partial mock by subclassing the original class
class URLSessionDataTaskMock: URLSessionDataTask {
    private let closure: () -> Void

    init(closure: @escaping () -> Void) {
        self.closure = closure
    }

    // We override the 'resume' method and simply call our closure
    // instead of actually resuming any task.
    override func resume() {
        closure()
    }
}

class URLSessionMock: URLSession {
    typealias CompletionHandler = (Data?, URLResponse?, Error?) -> Void

    // Properties that enable us to set exactly what data or error
    // we want our mocked URLSession to return for any request.
    var data: Data?
    var error: Error?
    
    override func dataTask(with request: URLRequest, completionHandler: @escaping CompletionHandler) -> URLSessionDataTask {
        let data = self.data
        let error = self.error
        
        return URLSessionDataTaskMock {
            completionHandler(data, nil, error)
        }
    }
}
