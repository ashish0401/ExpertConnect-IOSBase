//
// Created by Redbytes.
// Copyright (c) 2016 Redbytes. All rights reserved.
//

import Foundation
import UIKit

final class LoginWireFrame: LoginWireFrameProtocol {
    /**
     * Add here your methods for communication PRESENTER -> WIREFRAME
     */
    func openPaymentModule() {
        // Access payment module and open appropirate screen
    }
 
    class func setupLoginModule() -> UIViewController {
        // Generating module components
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let view: LoginViewProtocol  = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        
        let presenter: LoginPresenterProtocol & LoginInteractorOutputProtocol = LoginPresenter()
        let interactor: LoginInteractorInputProtocol = LoginInteractor()
        let APIDataManager: LoginAPIDataManagerInputProtocol = LoginAPIDataManager()
        let localDataManager: LoginLocalDataManagerInputProtocol = LoginLocalDataManager()
        let wireFrame: LoginWireFrameProtocol = LoginWireFrame()
        
        // Connecting
        view.presenter = presenter
        presenter.view = view
        presenter.wireFrame = wireFrame
        presenter.interactor = interactor
        interactor.presenter = presenter
        interactor.APIDataManager = APIDataManager
        interactor.localDataManager = localDataManager
        
        return view as! UIViewController
    }
    
    func openMenu() {
     //   MenuWireFrame.sharedInstance.openMenu()
    }
    
    func closeMenu() {
       // MenuWireFrame.sharedInstance.closeMenu()
    }
    
    func navigateToJoinModule() {
        
    }
    
    func navigateToForgotPasswordModule() {
        
    }

}
