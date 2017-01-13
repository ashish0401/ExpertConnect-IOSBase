

import Foundation

/**
 Validator for emails
*/
class EmailValidator: ValidatorProtocol {
    
    let emailRegEx = "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
    
    /**
     Validates the given email
     - parameters:
        - email: The email to be validated
     - returns: returns whether it is valid(true) or not(false)
     */
    func isValid(text email: String) -> Bool {
        let test = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return test.evaluate(with: email)
    }
}
