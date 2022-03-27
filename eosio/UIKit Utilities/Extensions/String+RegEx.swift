//
//  String+RegEx.swift
//  eosio
//
//  Created by Shayanairmee01 on 2022-03-27.
//

import UIKit

extension String {
    func isAccountValidate() -> Bool {
        let acountRegEx = "[a-z1-5\\.]{1,12}"
        
        let accontValidation = NSPredicate(format: "SELF MATCHES %@", acountRegEx)
        return accontValidation.evaluate(with: self)
    }
}
