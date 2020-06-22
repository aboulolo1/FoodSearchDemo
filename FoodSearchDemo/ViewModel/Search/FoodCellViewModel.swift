//
//  SearchCellViewModel.swift
//  FoodSearchDemo
//
//  Created by mac on 6/18/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
struct FoodCellViewModel {
    var model:Hit
    var image:URL?{
        if let urlString = model.recipe?.image {
            return URL(string: urlString)
        }
        return nil
    }
    var title:String{
        return model.recipe?.label ?? ""
    }
    var source:String{
        return model.recipe?.source ?? ""
    }
    var healthLabels:String {
        return model.recipe?.healthLabels?.joined(separator: " ") ?? ""
    }
}
