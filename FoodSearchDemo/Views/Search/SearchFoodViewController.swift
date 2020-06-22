//
//  SearchFoodViewController.swift
//  FoodSearchDemo
//
//  Created by mac on 6/18/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import RxSwift
import SearchTextField

class SearchFoodViewController: BaseViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchTextField: SearchTextField!
    let refreshController = UIRefreshControl()
    var viewModel:SearchViewModel?
    override var baseViewModel: BaseViewModel?{
        didSet{
            viewModel = baseViewModel as? SearchViewModel
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        baseViewModel = SearchViewModel()
        configureUI()
        configureBindings()
    }
    override func configureBindings() {
        super.configureBindings()
        configureBindingsTableView()
        configureSearchTextField()
        configureBingLoading()
    }
    private func configureSearchTextField(){
        guard let viewModel = viewModel else{return}
        viewModel.textFieldItemsSubject.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (searchItems) in
                guard let self = self else {return}
                self.searchTextField.filterItems(searchItems)
            }).disposed(by: viewModel.bag)
        searchTextField.userStoppedTypingHandler = {[weak self] in
            guard let self = self else {return}
            if let criteria = self.searchTextField.text {
                viewModel.getSuggestions(with: criteria)
            }
        }
    }
    private func configureBindingsTableView() {
        guard let viewModel = viewModel else{return}
        viewModel.dataSourceSubject.bind(to: tableView.rx.items(cellIdentifier: "FoodTableViewCell",cellType: FoodTableViewCell.self)) { row, cellViewModel, cell in
            cell.viewModel = cellViewModel
        }.disposed(by: viewModel.bag)
        tableView.rx.itemSelected.subscribe(onNext: { indexPath in
            viewModel.selectFoodeItem(index: indexPath.row)
        }).disposed(by:viewModel.bag)
        tableView.addInfiniteScroll { (collectionView) -> Void in
            self.tableView.performBatchUpdates({ [weak self]() -> Void in
                self?.viewModel?.getMoreData()
                }, completion: { (finished) -> Void in
                    // finish infinite scroll animations
                    self.tableView.finishInfiniteScroll()
            });
        }
        
    }
    private func configureBingLoading(){
        guard let viewModel = viewModel else{return}
        viewModel.showLoadingSubject.observeOn(MainScheduler.instance)
            .subscribe(onNext: { (loadingType) in
                if loadingType == .Search {
                    self.searchTextField.showLoadingIndicator()
                }
            }).disposed(by: viewModel.bag)
        viewModel.hideLoadingSubject.observeOn(MainScheduler.instance)
            .subscribe(onNext: { (loadingType) in
                if loadingType == .Search {
                    self.searchTextField.stopLoadingIndicator()
                }
            }).disposed(by: viewModel.bag)
        
    }
    private func configureUI(){
        self.navigationItem.title = "Food Search"
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: "FoodTableViewCell", bundle: nil), forCellReuseIdentifier: "FoodTableViewCell")
        tableView.delegate = self
        tableView.keyboardDismissMode = .onDrag
        searchTextField.delegate = self
        searchTextField.theme = SearchTextFieldTheme.darkTheme()
        searchTextField.theme.font = UIFont.systemFont(ofSize: 12)
        searchTextField.theme.bgColor = .black
        searchTextField.maxNumberOfResults = 10
    }
}
extension SearchFoodViewController:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.view.endEditing(true)
        viewModel?.getNewData(with: textField.text)
        return false
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        viewModel?.getSuggestions(with: textField.text ?? "")
    }
}
extension SearchFoodViewController:UITableViewDelegate{
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.searchTextField.hideResultsList()
    }
}
