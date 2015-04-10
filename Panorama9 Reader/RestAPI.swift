//
//  RestAPI.swift
//  Panorama9 Reader
//
//  Created by Jan Wiberg on 19/03/15.
//  Copyright (c) 2015 panorama9. All rights reserved.
//

import Foundation
import Alamofire

class RestAPI {
    let baseUrl = "https://dashboard.panorama9.com/api"
    var authKey: String?

    init() {
    }
    
    func setAuthKey(auth: String) {
        authKey = auth
    }
    
    func establishAuth() {
        let defaults = NSUserDefaults()
        authKey = defaults.stringForKey("p9ApiKey")
    }
    
    func isAuthable(key: String) -> Bool {
        let defaults = NSUserDefaults()
        return !key.isEmpty && count(key.utf16) == 64
    }
    
    func getDictionary(function: String, completion: ((received_data: NSDictionary?) -> Void)!, failure: ((message: String?) -> Void)!) {
        if self.authKey == nil {
            failure(message: "Authkey not set")
            return
        }
        var url : String = "\(self.baseUrl)/\(function)"
        let oauthKey = "OAuth " + self.authKey!
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Authorization": oauthKey]


        Alamofire.request(.GET, url).validate().responseJSON() {
            (_, res, data, error) in
            var statusCode: Int?
            if let response = res {
                statusCode = response.statusCode
            }
            if error == nil {
                println(data)
                completion(received_data: data as! NSDictionary?)
            } else {
                failure(message: "Code \(statusCode): \(error?.description)")
                println("Error: \(error)")
            }
        }
    }
    func getList(function: String, completion: ((received_data: NSArray?) -> Void)!, failure: ((message: String?) -> Void)!) {
        if self.authKey == nil {
            failure(message: "Authkey not set")
            return
        }
        var url : String = "\(self.baseUrl)/\(function)"
        let oauthKey = "OAuth " + self.authKey!
        Alamofire.Manager.sharedInstance.session.configuration.HTTPAdditionalHeaders = ["Authorization": oauthKey]
        
        
        Alamofire.request(.GET, url).responseJSON() {
            (_, res, data, error) in
            var statusCode: Int?
            if let response = res {
                statusCode = response.statusCode
            }
            if error == nil {
                println(data)
                completion(received_data: data as! NSArray?)
            } else {
                failure(message: "Code \(statusCode): \(error?.description)")
                println("Error: \(error)")
            }
        }
    }
}