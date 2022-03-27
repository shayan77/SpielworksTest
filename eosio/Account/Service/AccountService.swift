//
//  AccountService.swift
//  eosio
//
//  Created by Shayanairmee01 on 2022-03-27.
//

import Foundation

/*

 This is Account Service, responsible for making api calls of getting account.
 
*/

typealias AccountCompletionHandler = (Result<Account, RequestError>) -> Void

protocol AccountServiceProtocol {
    func getAccount(parameters: Parameters, completionHandler: @escaping AccountCompletionHandler)
}

/*
 AccountEndpoint is URLPath of Product Api calls
*/

private enum AccountEndpoint {
    
    case getAccount
    
    var path: String {
        switch self {
        case .getAccount:
            return "get_account"
        }
    }
}

class AccountService: AccountServiceProtocol {
    
    private let requestManager: RequestManagerProtocol
    
    public static let shared: AccountServiceProtocol = AccountService(requestManager: RequestManager.shared)
    
    // We can also inject requestManager for testing purposes.
    init(requestManager: RequestManagerProtocol) {
        self.requestManager = requestManager
    }
    
    func getAccount(parameters: Parameters, completionHandler: @escaping AccountCompletionHandler) {
        self.requestManager.performRequestWith(url: AccountEndpoint.getAccount.path, httpMethod: .post(parameters)) { (result: Result<Account, RequestError>) in
            completionHandler(result)
        }
    }
}
