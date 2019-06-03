//
//  CCError.swift
//  ios-code-challenge
//
//  Created by Rudy Matos on 6/3/19.
//  Copyright © 2019 Dustin Lange. All rights reserved.
//

import Foundation

struct CCError: Error{
    var message: String
    var type: ErrorType
    enum ErrorType{
        case errorGettingBusinesses
        case errorGettingLocationData
    }
}
