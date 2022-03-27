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

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
