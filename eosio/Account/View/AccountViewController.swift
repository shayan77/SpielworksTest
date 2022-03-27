//
//  AccountViewController.swift
//  eosio
//
//  Created by Shayanairmee01 on 2022-03-27.
//

import UIKit
import RxSwift
import RxCocoa

final class AccountViewController: UIViewController, Storyboarded {
    
    weak var coordinator: AppCoordinator?
    
    private var accountViewModel = AccountViewModel(accountService: AccountService.shared)
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

//        setupViews()
        setupBindings()
        callService()
    }
    
    private func callService() {
        accountViewModel.getAccountWith("womplayitems")
    }
    
    private func setupBindings() {
        
        accountViewModel.successResponse
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] result in
                guard let self = self else { return }
            }).disposed(by: disposeBag)
        
        accountViewModel.errorResponse
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                switch error {
                case .networkError(let error):
                    self.showAlertWith(error.localizedDescription)
                case .tooManyRequestError:
                    self.showAlertWith("Too Many Requests")
                }
            }).disposed(by: disposeBag)
        
//        countButton.rx.tap
//            .throttle(.seconds(1), scheduler: MainScheduler.instance)
//            .subscribe(onNext: { [weak self] in
//                guard let self = self else { return }
//                self.callService()
//            }).disposed(by: disposeBag)
    }
    
    private func showAlertWith(_ message: String) {
        let ac = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
}
