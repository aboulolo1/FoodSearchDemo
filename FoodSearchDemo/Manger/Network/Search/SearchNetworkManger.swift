//
//  SearchNetworkManger.swift
//  FoodSearchDemo
//
//  Created by mac on 6/18/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
class SearchNetworkManger:NetworkManger {
    typealias responseHandler = (Result<SearchModel?,ApiError>)->Void
    func searchFood(by parameter:[String:String], completion:@escaping responseHandler)  {
        let searchRouter = SearchRouter(endPoint: .searchFood(parameters: parameter))
        self.performNetworRequest(searchRouter) { (result) in
            completion(result)
        }
        
    }
}
