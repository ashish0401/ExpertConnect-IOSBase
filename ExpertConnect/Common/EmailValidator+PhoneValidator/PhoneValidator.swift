
import Foundation

/**
 Validator for phone numbers
*/
class PhoneValidator: ValidatorProtocol {
    
    let phoneRegEx = "^\\(\\d{3}\\) \\d{3}-\\d{4}$"
    
    /**
     Validates the given phone number
     - parameters:
        - phoneNumber: The phone number to be validated
     - returns: returns whether it is valid(true) or not(false)
     */
    func isValid(text phoneNumber: String) -> Bool {
        let test = NSPredicate(format:"SELF MATCHES %@", phoneRegEx)
        return test.evaluate(with: phoneNumber)
    }
}
