//
// Created by hhtopcu.
// Copyright (c) 2016 hhtopcu. All rights reserved.
//

import Foundation

final class LoginPresenter: LoginPresenterProtocol, LoginInteractorOutputProtocol {
    weak var view: LoginViewProtocol?
    var interactor: LoginInteractorInputProtocol?
    var wireFrame: LoginWireFrameProtocol?
    
    init() {}
    
    func notifyLoginButtonTapped() {
        let viewModel = view?.getLoginViewModel()

        if(viewModel != nil) {
            let model = LoginDomainModel(email: (viewModel?.email)!, password: (viewModel?.password)!, deviceToken:(viewModel?.deviceToken)!, operatingSysType: (viewModel?.operatingSysType)!)
            
            let message = "Processing".localized(in: "Login")
            view?.displayProgress(message: message)
            interactor?.authenticateUser(model: model)
        }
    }
    
    func notifyForgotPasswordButtonTapped() {
        let viewModel = view?.getForgotPasswordModel()
        if(viewModel != nil) {
            let model = FPDomainModel(email: (viewModel?.email)!)
            interactor?.forgotPasswordButtonTapped(model: model)
        }
    }

    /**
        This method will handle the typing, if one of the text fields are empty, login button should be deactivated
    */
    func notifyTextChangedInTextFields() {
        let viewModel = view?.getLoginViewModel()
        
        if(viewModel != nil) {
            let email = viewModel?.email
            let password = viewModel?.password
            
            if ((email?.isEmpty)! == false && (password?.isEmpty)! == false) {
              //  view?.activateLoginButton()
            } else {
              //  view?.deactivateLoginButton()
            }
        }
    }
    
    func notifyJoinButtonTapped() {
        wireFrame?.navigateToJoinModule()
    }
    
    /**
     * Add here your methods for communication VIEW -> PRESENTER
     */
    func notifyHamburgerMenuBarTapped() {
        wireFrame?.openMenu()
    }

    func onUserLoginSucceeded(data: LoginOutputDomainModel) {
        // Convert Domain Model to View Model
        // Send to wireframe to route somewhere else
       // print("Hey you logged in: \(data.fullName)")
        
        let userInfo = ["LoginOutputDomainModel": data] as [String: Any]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "com.ExpertConnect.loggedIn"), object: nil, userInfo:userInfo)
        UserDefaults.standard.set(true, forKey: "UserLoggedInStatus")

        view?.dismissProgress()
        view?.navigateBackToViewController()
    }
    
    func onUserLoginFailed(error: EApiErrorType) {
        // Update the view
        print("Ooops, there is a problem with your creditantials")
        view?.dismissProgress()
        
        let message = "Username or password is incorrect".localized(in: "Login")
        view?.displayErrorMessage(message: message)
    }
    
    func onForgotPasswordSucceeded(data: FPOutputDomainModel) {
        if data.status == true {
            //show alert of success
            print("show alert of success")
            let message = data.message
            view?.displaySuccessMessage(message: message)
        } else {
            let message = data.message
            view?.displayErrorMessage(message: message)
        }
    }
    
    func onForgotPasswordFailed(error: EApiErrorType) {
        //show alert of failuer
        print("show alert of failuer")
        let message = "email send failure".localized(in: "Login")
        view?.displayErrorMessage(message: message)
    }
  }
