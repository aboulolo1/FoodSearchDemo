//
//  BaseViewController.swift
//  FoodSearchDemo
//
//  Created by mac on 6/18/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import RxSwift
import SVProgressHUD
import SwiftMessageBar

class BaseViewController: UIViewController {
    
    var baseViewModel:BaseViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func configureBindings() {
        guard let baseViewModel = baseViewModel else{return}
        baseViewModel.pushViewControllerSubject.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (viewModel) in
                let viewController = BaseViewController.instantiateViewControllerFrom(viewModel: viewModel)
                if let navigationController =  self?.navigationController{
                    navigationController.pushViewController(viewController, animated: true)
                }
            }).disposed(by: baseViewModel.bag)
        
        baseViewModel.showLoadingSubject.observeOn(MainScheduler.instance)
            .subscribe(onNext: { (loadingType) in
                if loadingType == .Default {
                    SVProgressHUD.show()
                }
            }).disposed(by: baseViewModel.bag)
        
        baseViewModel.hideLoadingSubject.observeOn(MainScheduler.instance)
            .subscribe(onNext: { (loadingType) in
                if loadingType == .Default {
                    SVProgressHUD.dismiss()
                }
            }).disposed(by: baseViewModel.bag)
        
        baseViewModel.showAlertErrorSubject.observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] (err) in
                self?.showAlert(with: "Error", message: err, type: .error)
            }).disposed(by: baseViewModel.bag)
    }
}
extension UIViewController{
    static func instantiateViewControllerFrom(viewModel:BaseViewModel) -> BaseViewController{
        let storyboard = UIStoryboard(name: viewModel.viewIdentifier.storyboardIdentifier, bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier: viewModel.viewIdentifier.ViewControllerIdentifier) as! BaseViewController
        viewController.baseViewModel = viewModel
        return viewController
    }
    func showAlert(with title:String , message:String,type:MessageType) {
        SwiftMessageBar.showMessage(withTitle: title, message: message, type: type)
        
    }
}
