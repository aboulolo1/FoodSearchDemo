//
//  FoodTableViewCell.swift
//  FoodSearchDemo
//
//  Created by mac on 6/18/20.
//  Copyright © 2020 mac. All rights reserved.
//

import UIKit
import Kingfisher
class FoodTableViewCell: UITableViewCell {
   
    @IBOutlet weak var foodImage: UIImageView!
    
    @IBOutlet weak var foodHealth: UILabel!
    @IBOutlet weak var foodSource: UILabel!
    @IBOutlet weak var foodTitle: UILabel!
    var viewModel:FoodCellViewModel!{
           didSet{
               updateView()
           }
       }
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func updateView()  {
        self.foodImage.kf.setImage(with:  viewModel?.image, placeholder: UIImage(named: "not-available"))
        foodHealth.text = viewModel.healthLabels
        foodSource.text = viewModel.source
        foodTitle.text = viewModel.title
    }
}
