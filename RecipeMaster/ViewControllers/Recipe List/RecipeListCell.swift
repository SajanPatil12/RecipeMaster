//
//  RecipeListCell.swift
//  RecipeMaster
//
//  Created by sajan on 26/07/19.
//  Copyright © 2019 BISPL. All rights reserved.
//

import UIKit

class RecipeListCell: UITableViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var recipeImgView: UIImageView!
    @IBOutlet weak var reciprTitleLbl: UILabel!
    @IBOutlet weak var recipeDetailsLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
