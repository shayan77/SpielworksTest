//
//  HTTPMethod.swift
//  eosio
//
//  Created by Shayanairmee01 on 2022-03-27.
//

import Foundation

typealias Parameters = [String: Any]

protocol HTTPDataGenerator {
    var param: Parameters? { get }
    var paramData: Data? { get }
}

enum HTTPMethod {
    case get
    case post(Parameters?)
    
    var name: String {
        switch self {
        case .get:      return "GET"
        case .post:     return "POST"
        }
    }
}

extension HTTPMethod: HTTPDataGenerator {
    var param: Parameters? {
        switch self {
        case .get:     return nil
        case .post(let param):  return param
        }
    }
    
    var paramData: Data? {
        switch self {
        case .get:     return nil
        case .post(let param):  return try? dataGenerator(param: param)
        }
    }
    
    private func dataGenerator(param: Parameters?) throws -> Data? {
        guard let param = param else {return nil}
        do {
            let data = try JSONSerialization.data(withJSONObject: param, options: .prettyPrinted)
            return data
        }
    }
}
