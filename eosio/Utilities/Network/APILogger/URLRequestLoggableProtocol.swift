//
//  URLRequestLoggableProtocol.swift
//  eosio
//
//  Created by Shayanairmee01 on 2022-03-27.
//

import Foundation

protocol URLRequestLoggableProtocol {
    func logResponse(_ response: HTTPURLResponse?, data: Data?, error: Error?, HTTPMethod: String?)
}
