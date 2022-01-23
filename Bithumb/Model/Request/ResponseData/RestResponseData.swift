//
//  RestResponseData.swift
//  Bithumb
//
//  Created by JINHONG AN on 2022/01/18.
//

import Foundation

struct RestResponseData<Entity: Decodable> {
    struct CommonResponse: Decodable {
        let status: String
        let data: Entity
    }
    
    static func decode(data: Data) -> Result<Entity, RestError> {
        do {
            let result = try JSONDecoder().decode(CommonResponse.self, from: data)
            return .success(result.data)
        } catch  {
            return .failure(.parsingFailed)
        }
    }
    
    static func deserialize(data: Data) -> Result<[String: Entity], RestError> {
        do {
            let container = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            var data = container?["data"] as? [String: Any]
            data?.removeValue(forKey: "date")
            let result = try data?.mapValues { (value: Any) -> Entity in
                let valueData = try JSONSerialization.data(withJSONObject: value, options: [])
                return try JSONDecoder().decode(Entity.self, from: valueData)
            }
            guard let result = result else {
                throw RestError.parsingFailed
            }
            return .success(result)
        } catch {
            return .failure(.parsingFailed)
        }
    }
}
