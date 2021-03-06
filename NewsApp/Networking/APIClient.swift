//
//  APIClient.swift
//  NewsApp
//
//  Created by Aprizal on 24/3/21.
//

import Foundation
import Alamofire

class APIClient {
    
    private var dataRequest: DataRequest?
    let sessionManager: Session
    static let shared: APIClient = APIClient()
    
    init() {
        sessionManager = Session()
    }
    
    @discardableResult
    private func _dataRequest(
        url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = URLEncoding.default,
        headers: HTTPHeaders? = nil
    )
    -> DataRequest {
        return sessionManager.request(
            url,
            method: method,
            parameters: parameters,
            encoding: encoding,
            headers: headers
        )
    }
    
    func request<T: Codable>(route: APIRouter, completion: @escaping (Swift.Result<T, Error>) -> Void) {
        if let request = try? route.asURLRequest() {
            AF.request(request).responseData { (response) in
                print(response.request?.url?.absoluteString)
                switch response.result {
                case .success(let value):
                    let decoder = JSONDecoder()
                    let model = try? decoder.decode(T.self, from: value)
                    if let model = model {
                        completion(.success(model))
                    }
                case .failure(let error):
                    print("\(#line), \(#function), \(error.failureReason)")
                    completion(.failure(error))
                }
            }
        }
    }
    
    func requestTest<T: Codable>(route: APIRouter, completion: @escaping (Swift.Result<T, Error>) -> Void) {
        if let request = try? route.asURLRequestTest() {
            AF.request(request).responseData { (response) in
                print(response.request?.url?.absoluteString)
                switch response.result {
                case .success(let value):
                    let decoder = JSONDecoder()
                    let model = try? decoder.decode(T.self, from: value)
                    if let model = model {
                        completion(.success(model))
                    }
                case .failure(let error):
                    print("\(#line), \(#function), \(error.failureReason)")
                    completion(.failure(error))
                }
            }
        }
    }
}
