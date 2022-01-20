//
//  Repository.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/19.
//

import Foundation

protocol Repositoryable {
    var restService: RestServiceable { get }
    
    func execute<Request: RestRequestable>(request: Request, completion: @escaping (Result<Request.TargetDTO, Error>) -> Void)
}

final class Repository: Repositoryable {
    let restService: RestServiceable
    
    init(restService: RestServiceable = RestService()) {
        self.restService = restService
    }
    
    func execute<Request: RestRequestable>(request: Request, completion: @escaping (Result<Request.TargetDTO, Error>) -> Void) {
        let endPoint = EndPointFactory.makeRestEndPoint(from: request)
        restService.request(endPoint: endPoint) { result in
            switch result {
            case .success(let data):
                let parsedResult = request.parser(data)
                switch parsedResult {
                case .success(let DTO):
                    completion(.success(DTO))
                case .failure(let error):
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
