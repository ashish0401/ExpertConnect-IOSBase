//
// Created by hhtopcu.
// Copyright (c) 2016 hhtopcu. All rights reserved.
//

import Foundation
import UIKit

protocol LoginViewProtocol: class {
    var presenter: LoginPresenterProtocol? { get set }
    /**
     * Add here your methods for communication PRESENTER -> VIEW
     */
    func getLoginWithFacebookModel() -> LoginWithFacebookModel
    func getLoginViewModel() -> LoginViewModel
    func getForgotPasswordModel() -> FPDomainModel
    //func activateLoginButton()
    //func deactivateLoginButton()
    func displayProgress(message: String)
    func dismissProgress()
    func displayErrorMessage(message: String)
    func navigateBackToViewController()
    func displaySuccessMessage(message: String)
    func navigateToSignup()
}

protocol LoginWireFrameProtocol: class {
    static func setupLoginModule() -> UIViewController
    /**
     * Add here your methods for communication PRESENTER -> WIREFRAME
     */
    func openPaymentModule()
    func openMenu()
    func closeMenu()
    func navigateToJoinModule()
    func navigateToForgotPasswordModule()
}

protocol LoginPresenterProtocol: class {
    var view: LoginViewProtocol? { get set }
    var interactor: LoginInteractorInputProtocol? { get set }
    var wireFrame: LoginWireFrameProtocol? { get set }
    /**
     * Add here your methods for communication VIEW -> PRESENTER
     */
    func notifyTextChangedInTextFields()
    func notifyLoginButtonTapped()
    func notifyForgotPasswordButtonTapped()
    func notifyJoinButtonTapped()
    func notifyFacebookLoginButtonTapped()
}

protocol LoginInteractorOutputProtocol: class {
    /**
     * Add here your methods for communication INTERACTOR -> PRESENTER
     */
    func onUserLoginSucceeded(data: LoginOutputDomainModel)
    func onUserLoginFailed(error: EApiErrorType)
    func onUserLoginWithFacebookSucceeded(data: LoginOutputDomainModel)
    func onUserLoginWithFacebookFailed(error: EApiErrorType)
    func onForgotPasswordFailed(error: EApiErrorType)
    func onForgotPasswordSucceeded(data: FPOutputDomainModel)
}

protocol LoginInteractorInputProtocol: class {
    var presenter: LoginInteractorOutputProtocol? { get set }
    var APIDataManager: LoginAPIDataManagerInputProtocol? { get set }
    var localDataManager: LoginLocalDataManagerInputProtocol? { get set }
    /**
     * Add here your methods for communication PRESENTER -> INTERACTOR
     */
    func authenticateUser(model: LoginDomainModel)
    func forgotPasswordButtonTapped(model: FPDomainModel)
    func authenticateUserWithFacebook(model: LoginWithFacebookDomainModel)
}

protocol LoginDataManagerInputProtocol: class {
    /**
     * Add here your methods for communication INTERACTOR -> DATAMANAGER
     */
}

protocol LoginAPIDataManagerInputProtocol: class {
    /**
     * Add here your methods for communication INTERACTOR -> APIDATAMANAGER
     */
    func authenticateUser(model: LoginDomainModel, callback: @escaping (ECallbackResultType) -> Void)
    func forgotPassword(model: FPDomainModel, callback: @escaping (ECallbackResultType) -> Void)
    func authenticateUserWithFacebook(model: LoginWithFacebookDomainModel, callback: @escaping (ECallbackResultType) -> Void)
}

protocol LoginLocalDataManagerInputProtocol: class {
    /**
     * Add here your methods for communication INTERACTOR -> LOCALDATAMANAGER
     */
    func isUserAlreadyLoggedIn() -> Bool
}
