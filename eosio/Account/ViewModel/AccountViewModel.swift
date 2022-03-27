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
                self.accountNameWith(account.accountName ?? "-")
                self.getTotalBalanceWith(account.coreLiquidBalance ?? "-")
                self.calculateCpuLimitWith(account.cpuLimit)
                self.calculateNetLimitWith(account.netLimit)
                self.calculateRamLimitWith(account.ramUsage, total: account.ramQuota)
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
    
    public let accountName: PublishSubject<String> = PublishSubject()
    func accountNameWith(_ name: String) {
        accountName.onNext(name)
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
    
    public let netLimit: PublishSubject<String> = PublishSubject()
    func calculateNetLimitWith(_ limit: Limit?) {
        guard let netUsage = limit?.used else { return }
        if 0...1024 ~= netUsage {
            netLimit.onNext("\(netUsage) B")
        } else if 1025...1_048_576 ~= netUsage {
            let kb = netUsage / 1000
            netLimit.onNext(String(format: "%.2f", kb) + " KB")
        } else {
            let ms = netUsage / 1_000_000
            netLimit.onNext(String(format: "%.2f", ms) + " MB")
        }
    }
    
    public let ramLimit: PublishSubject<String> = PublishSubject()
    func calculateRamLimitWith(_ usage: Double?, total: Double?) {
        guard let ramUsage = usage else { return }
        var ramUsageString = ""
        if 0...1024 ~= ramUsage {
            ramUsageString = "\(ramUsage) B"
        } else if 1025...1_048_576 ~= ramUsage {
            let kb = ramUsage / 1000
            ramUsageString = String(format: "%.2f", kb) + " KB"
        } else {
            let ms = ramUsage / 1_000_000
            ramUsageString = String(format: "%.2f", ms) + " MB"
        }
        
        guard let totamRam = total else { return }
        var totalRamString = ""
        if 0...1024 ~= totamRam {
            totalRamString = "\(totamRam) B"
        } else if 1025...1_048_576 ~= totamRam {
            let kb = totamRam / 1000
            totalRamString = String(format: "%.2f", kb) + " KB"
        } else {
            let ms = totamRam / 1_000_000
            totalRamString = String(format: "%.2f", ms) + " MB"
        }
        
        ramLimit.onNext("\(ramUsageString) / \(totalRamString)")
    }
}
