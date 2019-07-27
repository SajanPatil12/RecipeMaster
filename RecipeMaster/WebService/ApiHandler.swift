//
//  ApiHandler.swift
//  RecipeMaster
//
//  Created by sajan on 23/07/19.
//  Copyright © 2019 BISPL. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ApiHandler: NSObject {

    static func getPostString(params:[String:Any]) -> String
    {
        var data = [String]()
        for(key, value) in params
        {
            data.append(key + "=\(value)")
        }
        return data.map { String($0) }.joined(separator: "&")
    }
    
    func postData(url: String, parameter: [String: AnyObject], completionHandler: @escaping (_ json: JSON, _ status: Bool) -> ())
    {
        //        let auth : String = MitraModal.sharedInstance().getBasicAuthenticationString()
        //        let headers = ["Authorization": auth]
        let headers = ["Authorization": ""]
        
        Alamofire.request(url, method: .post, parameters: parameter, encoding: URLEncoding.default, headers:headers) .validate()
            .responseJSON { response in
                
                if let temp = response.result.value
                {
                    let json = JSON(temp)
                    
                    if json == JSON.null
                    {
                        completionHandler(json, false)
                    }
                    else
                    {
                        completionHandler(json, true)
                    }
                }
                else
                {
                    if let data = response.data {
                        let json = String(data: data, encoding: String.Encoding.utf8)
                        
                        if let data = json?.data(using: .utf8) {
                            if let json = try? JSON(data: data) {
                                
                                completionHandler(json, false)
                            }
                        }
                        completionHandler(JSON.null, false)
                    }
                }
        }
    }
    
    func getData(url: String, completionHandler: @escaping (_ json: JSON, _ status: Bool) -> ())
    {
        Alamofire.request(url, method: .get, encoding: URLEncoding.default)
            .responseJSON { response in
                
                if let temp = response.result.value
                {
                    let json = JSON(temp)
                    
                    if json == JSON.null
                    {
                        completionHandler(json, false)
                    }
                    else
                    {
                        completionHandler(json, true)
                    }
                }
                else
                {
                    completionHandler(JSON.null, false)
                }
        }
    }

}
