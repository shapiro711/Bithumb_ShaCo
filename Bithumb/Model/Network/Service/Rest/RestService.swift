//
//  RestService.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/15.
//

import Foundation

struct RestService: RestServiceable {
    let networkConfigure: NetworkConfigurable
    private let sessionManager: RestSessionManageable
    
    init(
        networkConfigure: NetworkConfigurable = RestConfigure(),
        sessionMaanger: RestSessionManageable = RestSessionManager()
    ) {
        self.networkConfigure = networkConfigure
        self.sessionManager = sessionMaanger
    }
    
    func request(endPoint: RestEndPointable, completion: @escaping (Result<Data, RestError>) -> Void) {
        do {
            let urlRequest = try generateURLRequest(endPoint: endPoint)
            sessionManager.request(urlRequest: urlRequest) { data, response, error in
                if let error = error {
                    return completion(.failure(.undefined(error)))
                }
                guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                    return completion(.failure(RestError.abnormalResponse))
                }
                guard let data = data else {
                    return completion(.failure(RestError.notExistData))
                }
                completion(.success(data))
            }
        } catch RestError.urlGeneration {
            completion(.failure(.urlGeneration))
        } catch {
            completion(.failure(.undefined(error)))
        }
    }
    
    private func generateURL(endPoint: RestEndPointable) throws -> URL {
        let baseURL = networkConfigure.baseURLString
        let fullPath = baseURL + endPoint.path
        var urlComponents = URLComponents(string: fullPath)
        var urlQueryItems = [URLQueryItem]()
        let queryParameters = endPoint.queryParameters
        
        queryParameters?.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        urlComponents?.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents?.url else {
            throw RestError.urlGeneration
        }
        return url
    }
    
    private func generateURLRequest(endPoint: RestEndPointable) throws -> URLRequest {
        let url = try generateURL(endPoint: endPoint)
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = endPoint.httpMethod.methodName
        return urlRequest
    }
}
