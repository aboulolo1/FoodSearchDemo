//
//  Router.swift
//  FoodSearchDemo
//
//  Created by mac on 6/18/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

enum HttpMethod : String {
    case get = "Get"
    case post = "Post"
}

typealias httpHeaders = [String:String]
typealias httpParameters = [String:String]

protocol Router {
    var path:String{get}
    var baseUrl:String{get}
    var scheme:String{get}
    var method:HttpMethod { get }
    var headers:httpHeaders? { get }
    var baseParameter:httpParameters? { get}
    var parameter:httpParameters? { get}
    var body:httpParameters? { get }
}
extension Router{
    var headers:httpHeaders?{
        return ["content-type":"application/json","Accept":"application/json"]
    }
    var baseParameter:httpParameters?{
        get{
            return ["app_key":Constant.appKey,"app_id":Constant.appId]
        }
    }
    var baseUrl:String{
        return "api.edamam.com"
    }
    
    var body:httpParameters?{
        return nil
    }
    
    var scheme:String{
           return "https"
       }
}
