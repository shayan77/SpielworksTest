//
//  Test_AccountService.swift
//  eosioTests
//
//  Created by Shayanairmee01 on 2022-03-27.
//

import XCTest
@testable import eosio

final class AccountServiceTests: XCTestCase {
    
    var sut: AccountService?
    var accountJson: Data?
    
    override func setUp() {
        let bundle = Bundle(for: type(of: self))
        if let path = bundle.path(forResource: "get_account", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                self.accountJson = data
            } catch {
                
            }
        }
    }
    
    override func tearDown() {
        sut = nil
    }
    
    func test_getApartmentsList() {
        
        // Given
        let urlSessionMock = URLSessionMock()
        urlSessionMock.data = accountJson
        let mockRequestManager = RequestManagerMock(session: urlSessionMock, validator: MockResponseValidator())
        sut = AccountService(requestManager: mockRequestManager)
        let expectation = XCTestExpectation(description: "Async next path test")
        var account: Account?
        let parameter: Parameters = [
            "account_name": "wombatresmgr"
        ]
        
        // When
        sut?.getAccount(parameters: parameter, completionHandler: { (result) in
            defer {
                expectation.fulfill()
            }
            switch result {
            case .success(let accountDetail):
                account = accountDetail
            case .failure:
                XCTFail()
            }
        })
        
        // Then
        wait(for: [expectation], timeout: 5)
        XCTAssertTrue(account?.accountName == "wombatresmgr")
    }
}
