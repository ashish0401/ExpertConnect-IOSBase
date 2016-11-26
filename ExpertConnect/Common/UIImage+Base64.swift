//
//  UIImage+Base64.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

extension UIImage {
    func convertImageToBase64(image: UIImage) -> String {
        
        var imageData = UIImagePNGRepresentation(image)
        let base64String = imageData?.base64EncodedString()
        
        return base64String!
        
    }
    
    func convertBase64ToImage(base64String: String) -> UIImage {
        
        let decodedData = NSData(base64Encoded: base64String, options: NSData.Base64DecodingOptions(rawValue: 0) )
        
        var decodedimage = UIImage(data: decodedData! as Data)
        
        return decodedimage!
    }
}
