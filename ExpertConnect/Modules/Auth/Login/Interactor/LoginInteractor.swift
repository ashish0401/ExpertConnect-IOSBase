//
// Created by hhtopcu.
// Copyright (c) 2016 hhtopcu. All rights reserved.
//

import Foundation

final class LoginInteractor: LoginInteractorInputProtocol {
    weak var presenter: LoginInteractorOutputProtocol?
    var APIDataManager: LoginAPIDataManagerInputProtocol?
    var localDataManager: LoginLocalDataManagerInputProtocol?
    
    init() {}
    
    func authenticateUser(model: LoginDomainModel) {
        let userAlreadyLoggedIn = localDataManager?.isUserAlreadyLoggedIn()
        
        if (userAlreadyLoggedIn)! {
            // presenter.
        } else {
            APIDataManager?.authenticateUser(model: model, callback: { (result) in
                switch result {
                case .Failure(let error):
                    self.presenter?.onUserLoginFailed(error: error)
                case .Success(let data as LoginOutputDomainModel):
                    do {
                        try UserService.sharedInstance.createUser(username: data.firstName, token: "Example-Token")
                        self.presenter?.onUserLoginSucceeded(data: data)
                    } catch {
                        self.presenter?.onUserLoginFailed(error: EApiErrorType.InternalError)
                    }
                default:
                    break
                }
            })
        }
    }
    
    func forgotPasswordButtonTapped(model: FPDomainModel) {
        APIDataManager?.forgotPassword(model: model , callback: { (result) in
            print(result)
            switch result {
                
            case .Failure(let error):
                self.presenter?.onForgotPasswordFailed(error: error)
            case .Success(let data as FPOutputDomainModel):
                self.presenter?.onForgotPasswordSucceeded(data: data)
            default:
                break
            }
        })
    }
}
