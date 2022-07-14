//
//  CoreAPI.swift
//  movieChallenge
//
//  Created by Tequilan on 13/07/2022.
//

import Alamofire
import SwiftyJSON

typealias NetworkingCompletion = (JSON, BackendResponse) -> Void
typealias ViewCompletionHander = (Bool, String?) -> Void // passing isSucceed and responsed message

struct CoreAPI {
    static func isConnectionAvailable() -> Bool{
        return NetworkReachabilityManager()!.isReachable
    }
    
    static func makeRequest(endPoint: String,
                            method: HTTPMethod,
                            parameters: Dictionary<String, Any>? = nil,
                            encoding: ParameterEncoding = URLEncoding.default,
                            completion: @escaping NetworkingCompletion) {
        
        let manager = Alamofire.SessionManager.default
        manager.session.configuration.timeoutIntervalForRequest = 120
        
        let dataRequest = request(endPoint,
                                  method: method,
                                  parameters: parameters,
                                  encoding: encoding,
                                  headers: nil)
        print("endpoints: \(endPoint)")
        print("parameters: \(String(describing: parameters))")
        dataRequest.responseJSON { responseObject in
            self.handleResponseJSON(endpoint: endPoint,
                                    responseObject: responseObject,
                                    completion: completion)
        }
    }
    
    fileprivate static func handleResponseJSON(endpoint: String,
                                               responseObject:DataResponse<Any>,
                                               completion: @escaping NetworkingCompletion) {
        var jsonResponse = JSON()
        do {
            jsonResponse = try JSON(data: responseObject.data!)
        }
        catch {
            let backendResponse = BackendResponse(inResponseCode: -998, inMessage: "A Problem occurred, please contact the administrator.", isSucceed: false)
            completion(JSON(), backendResponse)
        }
        
        var message = jsonResponse["message"].exists() ? jsonResponse["message"].stringValue : ""
        var retCode = responseObject.response?.statusCode
        print("retCode: \(String(describing: retCode)) for endpoint: \(endpoint)")
        print("jsonResponse: \(jsonResponse)")
        var isSucceed = false
        
        if retCode != 200, retCode != 201 {
            // error handling
            if !CoreAPI.isConnectionAvailable() {
                message = "The Internet connection appears to be offline"
                retCode = Constants.NETWORK_ERROR_CODE
            }
            isSucceed = false
        } else {
            isSucceed = true
        }
        
        let backendResponse = BackendResponse(inResponseCode: retCode, inMessage: message, isSucceed: isSucceed)
        completion(jsonResponse, backendResponse)
    }
}
