

import Foundation

/**
 Validator factory is used for getting a validator protocol according to input type which can be Phone, Email or Default. New types can be added later
*/
class ValidatorFactory {
    
    /**
     Create the validator according to the input type
     - parameters:
        - inputText: The input text to be validated
     - returns: returns the validator
     */
    func create(type: EInputType) -> ValidatorProtocol {
        switch type {
            case EInputType.EMAIL:
                return EmailValidator()
            case EInputType.PHONE:
                return PhoneValidator()
            default:
                return PlainTextValidator()
        }
    }
}
