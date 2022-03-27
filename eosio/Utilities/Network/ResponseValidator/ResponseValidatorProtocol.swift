//
//  ResponseValidatorProtocol.swift
//  eosio
//
//  Created by Shayanairmee01 on 2022-03-27.
//

import Foundation

protocol ResponseValidatorProtocol {
    func validation<T: Codable>(response: HTTPURLResponse?, data: Data?) -> Result<T, RequestError>
}
