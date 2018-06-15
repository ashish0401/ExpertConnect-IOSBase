//
//  MessagesViewInputDomainModel.swift
//  ExpertConnect
//
//  Created by Nadeem on 24/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

class MessagesViewOutputDomainModel {
    var status = false
    var messages: NSDictionary = NSDictionary() as NSDictionary
    var sent: NSArray = [NSDictionary]() as NSArray
    var received: NSArray = [NSDictionary]() as NSArray
}
