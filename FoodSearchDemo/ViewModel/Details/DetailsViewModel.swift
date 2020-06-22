//
//  DetailsViewModel.swift
//  FoodSearchDemo
//
//  Created by mac on 6/22/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation

class DetailsViewModel:BaseViewModel {
    override var viewIdentifier: ViewIdentifier!{
        get{
            return ViewIdentifier(storyboardIdentifier: "Main", ViewControllerIdentifier: "DetailsViewController")
        }
        set{}
    }
    private var cellViewModel:FoodCellViewModel
    init(_ cellViewModel:FoodCellViewModel) {
        self.cellViewModel = cellViewModel
    }
    var imageUrl : URL?{
        return cellViewModel.image
    }
    var title:String {
        return cellViewModel.title
    }
    var ingredientLines:String {
        return cellViewModel.model.recipe?.ingredientLines?.joined(separator: "\n\n") ?? ""
    }
    var publisherUrl:URL?{
        if let urlString = cellViewModel.model.recipe?.url {
            return URL(string: urlString)
        }
        return nil
    }
    var publisherUrlStr:String{
        return cellViewModel.model.recipe?.url ?? ""
    }
}
