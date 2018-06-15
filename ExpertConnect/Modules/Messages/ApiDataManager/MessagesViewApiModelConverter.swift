//
//  MessagesViewApiModelConverter.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

import SwiftyJSON

class MessagesViewApiModelConverter {
    
    /**
     This method converts raw JSON data to model
     - parameters:
     - json: raw json data
     - returns: Authenticated User Model
     */
    func fromJson(json: JSON) -> MessagesViewOutputDomainModel {
        let status = json["status"].boolValue
        let messages = json["message"].dictionaryObject
        let sent = json["message"]["Sent List"].arrayObject
        let received = json["message"]["Received List"].arrayObject

        // Form the model to be sent
        let model: MessagesViewOutputDomainModel = MessagesViewOutputDomainModel()
        model.messages = messages! as NSDictionary
        model.sent = sent! as NSArray
        model.received = received! as NSArray
        model.status = status

        return model
    }
    
    func fromJson(json: JSON) -> EnquiryViewOutputDomainModel {
        let status = json["status"].boolValue
        let enquiryList = json["enquiryList"].arrayObject
        
        // Form the model to be sent
        let model: EnquiryViewOutputDomainModel = EnquiryViewOutputDomainModel()
        model.enquiryList = enquiryList! as NSArray
        model.status = status
        
        return model
    }
    
    func fromJson(json: NSDictionary) -> MessageModel {
        let userId = json["userId"]
        let userName = json["userName"]
        let profilePic = json["profile_pic"]
        let message = json["message"]
        let messageDate = json["date"]
        
        // Form the model to be sent
        let model: MessageModel = MessageModel()
        model.userId = userId as! String
        model.userName = userName as! String
        model.profilePic = profilePic as! String
        model.message = message as! String
        model.date = messageDate as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
        let date = dateFormatter.date(from: model.date)
        print("date: \(String(describing: date))")
        dateFormatter.dateFormat = "h:mm a - dd MMM, yyyy"
        let dateString = dateFormatter.string(from: date!)
        model.date = dateString
        
        return model
    }
    
    func fromJson(json: NSDictionary) -> EnquiryModel {
        let enquiryId = json["enquiry_id"]
        let userId = json["user_id"]
        let userName = json["userName"]
        let profilePic = json["profile_pic"]
        let message = json["message"]
        let messageDate = json["date"]
        
        // Form the model to be sent
        let model: EnquiryModel = EnquiryModel()
        model.enquiryId = enquiryId as! String
        model.userId = userId as! String
        model.userName = userName as! String
        model.profilePic = profilePic as! String
        model.message = message as! String
        model.date = messageDate as! String
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        dateFormatter.dateFormat = "yyyy-mm-dd HH:mm:ss"
        let date = dateFormatter.date(from: model.date)
        print("date: \(String(describing: date))")
        dateFormatter.dateFormat = "h:mm a - dd MMM, yyyy"
        let dateString = dateFormatter.string(from: date!)
        model.date = dateString
        
        return model
    }
    
    func fromJson(json: JSON) -> OTPOutputDomainModel {
        let status = json["status"].boolValue
        let message = json["message"].stringValue
        // Form the model to be sent
        let model: OTPOutputDomainModel = OTPOutputDomainModel()
        model.message = message
        model.status = status
        return model
    }
}
