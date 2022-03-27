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
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var accountNameTextField: UITextField!
    @IBOutlet weak var totalBalanceLabel: UILabel!
    
    weak var coordinator: AppCoordinator?
    
    private var accountViewModel = AccountViewModel(accountService: AccountService.shared)
    
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupBindings()
    }
    
    private func setupViews() {
        accountNameTextField
            .rx.text
            .debounce(.seconds(1), scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] query in
                guard let query = query else { return }
                self.accountViewModel.getAccountNameWith(query)
            }).disposed(by: disposeBag)
    }
    
    private func setupBindings() {
        
        accountViewModel.loading
            .bind(to: activityIndicator.rx.isAnimating)
            .disposed(by: disposeBag)
        
        accountViewModel.loading
            .map {!$0}
            .observe(on: MainScheduler.instance)
            .bind(to: accountNameTextField.rx.isUserInteractionEnabled)
            .disposed(by: disposeBag)
        
        accountViewModel.totalBalance
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] balance in
                guard let self = self else { return }
                self.totalBalanceLabel.text = balance
            }).disposed(by: disposeBag)
        
        accountViewModel.errorResponse
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] error in
                guard let self = self else { return }
                switch error {
                case .networkError(let error):
                    self.showAlertWith(error.localizedDescription)
                case .notValidAccountName:
                    self.showAlertWith(error.errorValue)
                }
            }).disposed(by: disposeBag)
    }
    
    private func showAlertWith(_ message: String) {
        let ac = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(ac, animated: true, completion: nil)
    }
}
