//
//  RestService.swift
//  Bithumb
//
//  Created by Kim Do hyung on 2022/01/15.
//

import Foundation

struct RestService: RestServiceable {
    var networkConfigure: NetworkConfigurable
    
    init(networkConfigure: NetworkConfigurable = RestConfigure()) {
        self.networkConfigure = networkConfigure
    }
    
    func request(endPoint: RestEndPointable, completion: @escaping (Result<Data, Error>) -> Void) {
        
    }
    
    private func generateURL(endPoint: RestEndPointable) throws -> URL {
        let baseURL = networkConfigure.baseURLString
        let fullPath = baseURL + endPoint.path.specializedPath
        var urlComponents = URLComponents(string: fullPath)
        var urlQueryItems = [URLQueryItem]()
        let queryParameters = endPoint.queryParameters
        
        queryParameters?.forEach {
            urlQueryItems.append(URLQueryItem(name: $0.key, value: "\($0.value)"))
        }
        urlComponents?.queryItems = !urlQueryItems.isEmpty ? urlQueryItems : nil
        guard let url = urlComponents?.url else {
            throw NetworkError.urlGeneration
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
