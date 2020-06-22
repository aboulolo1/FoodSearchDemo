//
//  SearchViewModel.swift
//  FoodSearchDemo
//
//  Created by mac on 6/18/20.
//  Copyright © 2020 mac. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa
import SearchTextField

class SearchViewModel:BaseViewModel {
    
    private let networkManger: SearchNetworkManger
    private var fromPage = 0
    private var toPage = 10
    private var totalPages = 10
    private var dataSource:[FoodCellViewModel] = []
    private var searchDataSource:[FoodCellViewModel?] = []
    private var searchText:String?
    var dataSourceSubject = PublishSubject<[FoodCellViewModel]>()
    var textFieldItemsSubject = PublishSubject<[SearchTextFieldItem]>()
    
    init(networkManger: SearchNetworkManger = SearchNetworkManger()) {
        self.networkManger = networkManger
    }
    func getNewData(with query:String?){
        searchText = query
        fromPage = 0
        toPage = 10
        totalPages = 10
        dataSource.removeAll()
        searchFood(.Default)
    }
    func getMoreData() {
        if toPage > totalPages {
            return
        }
        fromPage += 10
        toPage += 10
        searchFood(.InfiniteScroll)
    }
    func getSuggestions(with terms:String) {
        let parameter = ["from":"\(0)","to":"\(10)","q":terms]
        if terms.count % 2 == 0{
            getSearchResult(parameter,true,.Search)
        }
    }
    func selectFoodeItem(index:Int) {
        let cellViewModel = dataSource[index]
        let detealisViewModel = DetailsViewModel(cellViewModel)
        self.pushViewControllerSubject.onNext(detealisViewModel)
    }
    private func searchFood(_ loadingType:LoadingType)  {
        if let searchText = searchText{
            let parameter = ["from":"\(fromPage)","to":"\(toPage)","q":searchText]
            getSearchResult(parameter,false,loadingType)
        }
        
    }
    private func getSearchResult(_ parameter:[String:String],_ isSuggest:Bool,_ loadingType:LoadingType){
        self.showLoadingSubject.onNext(loadingType)
        networkManger.searchFood(by: parameter){ [weak self](result) in
            guard let self = self else{return}
            self.hideLoadingSubject.onNext(loadingType)
            switch result{
            case .success(let model):
                if let model = model{
                    if isSuggest {
                        self.configureSearchDataSource(model)
                    }else{
                        self.configurehDataSource(model)
                    }
                }
            case .failure(let error):
                self.showAlertErrorSubject.onNext(error.localizedDescritpion)
            }
        }
    }
    private func configurehDataSource(_ searchModel:SearchModel){
        totalPages = searchModel.count ?? 0
        guard let hits = searchModel.hits  else {
            self.showAlertErrorSubject.onNext("An Error happened , please try again")
            return
        }
        if hits.count == 0{
            self.showAlertErrorSubject.onNext("No Data Found")
        }
        else{
            let foodCellViewModelArray = hits.map{FoodCellViewModel(model: $0)}
            dataSource.append(contentsOf: foodCellViewModelArray)
            dataSourceSubject.onNext(dataSource)
        }
    }
    private func configureSearchDataSource(_ searchModel:SearchModel)  {
        if let hits = searchModel.hits, hits.count != 0{
            let foodCellViewModelArray = hits.map{FoodCellViewModel(model: $0)}
            searchDataSource = foodCellViewModelArray
            textFieldItemsSubject.onNext(searchDataSource.map{SearchTextFieldItem(title: $0!.title)})
        }
    }
}
