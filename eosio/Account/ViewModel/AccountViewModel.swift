//
//  AccountViewModel.swift
//  eosio
//
//  Created by Shayanairmee01 on 2022-03-27.
//

import Foundation
import RxSwift

final class AccountViewModel {
        
    enum AccountError {
        
        case networkError(RequestError)
        case tooManyRequestError
        
        var errorValue: String {
            switch self {
            case .networkError(let error):
                return error.localizedDescription
            case .tooManyRequestError:
                return "Too Many Request"
            }
        }
    }
    
    private var accountService: AccountServiceProtocol
    private var nextPath: String?
    
    init(accountService: AccountServiceProtocol) {
        self.accountService = accountService
    }
    
    public let successResponse: PublishSubject<Account> = PublishSubject()
    public let errorResponse: PublishSubject<AccountError> = PublishSubject()
    
    func getAccountWith(_ name: String) {
        
        let parameter: Parameters = [
            "account_name": name
        ]
        
        accountService.getAccount(parameters: parameter) { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let account):
                self.successResponse.onNext(account)
            case.failure(let requestError):
                self.errorResponse.onNext(.networkError(requestError))
            }
        }
    }
}
