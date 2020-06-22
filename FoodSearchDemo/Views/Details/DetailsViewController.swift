//
//  DetailsViewController.swift
//  FoodSearchDemo
//
//  Created by mac on 6/22/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import SafariServices
class DetailsViewController: BaseViewController {

    @IBOutlet weak var publishUrlBtn: UIButton!
    @IBOutlet weak var ingredient: UILabel!
    @IBOutlet weak var titleFood: UILabel!
    @IBOutlet weak var imgFood: UIImageView!
    var viewModel:DetailsViewModel?
       override var baseViewModel: BaseViewModel?{
           didSet{
               viewModel = baseViewModel as? DetailsViewModel
           }
       }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = viewModel?.title
        self.imgFood.kf.setImage(with:  viewModel?.imageUrl, placeholder: UIImage(named: "not-available"))
        self.titleFood.text = viewModel?.title
        self.ingredient.text = viewModel?.ingredientLines
        self.publishUrlBtn.setTitle(viewModel?.publisherUrlStr, for: .normal)
    }
    

    @IBAction func openUrl(_ sender: Any) {
        if let url = viewModel?.publisherUrl{
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true
            let vc = SFSafariViewController(url:url , configuration: config)
            present(vc, animated: true)
        }
    }
    
}
