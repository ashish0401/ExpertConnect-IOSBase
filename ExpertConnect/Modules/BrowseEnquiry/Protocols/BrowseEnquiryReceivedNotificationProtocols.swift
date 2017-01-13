//
//  BrowseEnquiryReceivedNotificationProtocols.swift
//  ExpertConnect
//
//  Created by Redbytes on 21/11/16.
//  Copyright © 2016 user. All rights reserved.
//

import Foundation

protocol BrowseEnquiryReceivedNotificationProtocols {

    func getBrowseEnquiryReceivedNotificationDetails(model: BrowseEnquiryReceivedNotificationDomainModel, callback: @escaping (ECallbackResultType) -> Void)

}
