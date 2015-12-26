//
//  request.swift
//  CarPooling
//
//  Created by Ali Sultan on 12/26/15.
//  Copyright © 2015 Badr AlKhamissi. All rights reserved.
//

import Foundation

//MARK: Request Status
enum requestStatus{
    case approved
    case pending
    case rejected
}

struct Request{
    //User Making the Request
    let requester:User?
    //User requesting the request
    let requestee:User?
    //status of request
    var status:requestStatus
}
