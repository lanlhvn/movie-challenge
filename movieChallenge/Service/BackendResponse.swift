//
//  BackendResponse.swift
//  MovieChallenge
//
//  Created by Tequilan on 13/07/2022.
//

import Foundation

class BackendResponse: NSObject {
    var isSucceed: Bool = false
    var retCode: Int? = -1
    var message = ""
    
    init(inResponseCode code: Int?, inMessage msg: String, isSucceed success: Bool) {
        retCode = code
        message = msg
        isSucceed = success
    }
}
