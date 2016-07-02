//
//  Network.swift
//  CourseSourcer
//
//  Created by Charlie on 6/10/16.
//  Copyright © 2016 cd17822. All rights reserved.
//

import Foundation
import UIKit
import Alamofire
import SwiftyJSON

let env = "localhost" //"192.168.1.4"

func GET(endpoint: String, callback: (err: [String:AnyObject]?, res: JSON?) -> Void) {
    Alamofire.request(.GET, "http://\(env):3005\(endpoint)").responseJSON { response in
        print("GET:", "http://\(env):3005\(endpoint)")
        
        switch response.result {
        case .Success:
            if let res = response.result.value {
                callback(err: nil, res: JSON(res))
            }
            break
        case .Failure(let error):
            print("NETWORK ERROR:", response)
            callback(err: ["error": error], res: nil)
        }
    }
}

func POST(endpoint: String, parameters: [String:String], callback: (err: [String:AnyObject]?, res: JSON?) -> Void) {
    Alamofire.request(.POST, "http://\(env):3005\(endpoint)", parameters: parameters, encoding: .JSON).responseJSON { response in
        print("POST:", "http://\(env):3005\(endpoint)")
        
        switch response.result {
        case .Success:
            if let res = response.result.value {
                callback(err: nil, res: JSON(res))
            }
            break
        case .Failure(let error):
            print("NETWORK ERROR:", response)
            callback(err: ["error": error], res: nil)
        }
    }
}

func PUT(endpoint: String, parameters: [String:String], callback: (err: [String:AnyObject]?, res: JSON?) -> Void) {
    Alamofire.request(.PUT, "http://\(env):3005\(endpoint)", parameters: parameters, encoding: .JSON).responseJSON { response in
        print("PUT:", "http://\(env):3005\(endpoint)")
        
        switch response.result {
        case .Success:
            if let res = response.result.value {
                callback(err: nil, res: JSON(res))
            }
            break
        case .Failure(let error):
            print("NETWORK ERROR:", response)
            callback(err: ["error": error], res: nil)
        }
    }
}
