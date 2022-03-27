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
        case notValidAccountName
        
        var errorValue: String {
            switch self {
            case .networkError(let error):
                return error.localizedDescription
            case .notValidAccountName:
                return "Account name is not valid"
            }
        }
    }
    
    private var accountService: AccountServiceProtocol
    private var nextPath: String?
    
    init(accountService: AccountServiceProtocol) {
        self.accountService = accountService
    }
    
    public let errorResponse: PublishSubject<AccountError> = PublishSubject()
    public let loading: PublishSubject<Bool> = PublishSubject()
    
    private func getAccountDataWith(_ name: String) {
        
        let parameter: Parameters = [
            "account_name": name
        ]
        
        loading.onNext(true)
        accountService.getAccount(parameters: parameter) { [weak self] result in
            guard let self = self else { return }
            self.loading.onNext(false)
            switch result {
            case .success(let account):
                self.getTotalBalanceWith(account.coreLiquidBalance ?? "-")
                self.calculateCpuLimitWith(account.cpuLimit)
            case.failure(let requestError):
                self.errorResponse.onNext(.networkError(requestError))
            }
        }
    }
    
    func getAccountNameWith(_ name: String) {
        if !name.isEmpty {
            if name.isAccountValidate() {
                self.getAccountDataWith(name)
            } else {
                self.errorResponse.onNext(.notValidAccountName)
            }
        }
    }
    
    public let totalBalance: PublishSubject<String> = PublishSubject()
    func getTotalBalanceWith(_ balance: String) {
        totalBalance.onNext(balance)
    }
    
    public let cpuLimit: PublishSubject<String> = PublishSubject()
    func calculateCpuLimitWith(_ limit: Limit?) {
        guard let cpuUsage = limit?.used else { return }
        if 0...1000 ~= cpuUsage {
            cpuLimit.onNext("\(cpuUsage) µs")
        } else if 1001...1_000_000 ~= cpuUsage {
            let ms = cpuUsage / 1000
            cpuLimit.onNext(String(format: "%.2f", ms) + " ms")
        } else {
            let ms = cpuUsage / 1_000_000
            cpuLimit.onNext(String(format: "%.2f", ms) + " s")
        }
    }
}
