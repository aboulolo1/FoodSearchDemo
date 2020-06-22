//
//  SearchRouter.swift
//  FoodSearchDemo
//
//  Created by mac on 6/18/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
enum SearchPoint {
    case searchFood(parameters:[String:String])
}
struct SearchRouter:Router {
    
    var endPoint:SearchPoint
    var path: String{
        switch endPoint {
        case .searchFood:
            return "/search"
        }
    }
    
    var method: HttpMethod{
        switch endPoint {
        case .searchFood:
            return .get
        }
    }
    var parameter: httpParameters?{
        switch endPoint {
        case .searchFood(let parameter):
            var mutableParamter = baseParameter
            for (key, value) in parameter {
                mutableParamter?[key] = value
            }
            return mutableParamter
        }
    }
    
    
}
