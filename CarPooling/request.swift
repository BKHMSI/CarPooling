//
//  request.swift
//  CarPooling
//
//  Created by Ali Sultan on 12/26/15.
//  Copyright © 2015 Badr AlKhamissi. All rights reserved.
//

import Foundation

enum requestStatus{
    case approved
    case pending
    case rejected
}

struct Request{
    let requester:User?
    let requestee:User?
    var status:requestStatus
}
