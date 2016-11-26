

import Foundation

/**
 Validator for default plain texts
*/
class PlainTextValidator: ValidatorProtocol {

    /**
     Returns true if input type is DEFAULT
     - parameters:
        - text: The phone number to be validated
     - returns: returns valid(true)
     */
    func isValid(text: String) -> Bool {
        return true
    }
}
