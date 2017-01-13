

import Foundation

/**
 It is a interface for validator
*/
protocol ValidatorProtocol {
 
    /**
     Checks the input text against the regex pattern
     - parameters:
        - text: The input text to be validated
     - returns: returns whether it is valid(true) or not(false)
     */
    func isValid(text: String) -> Bool
}
