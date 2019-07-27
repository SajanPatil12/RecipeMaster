//
//  Recipe.swift
//  RecipeMaster
//
//  Created by sajan on 26/07/19.
//  Copyright © 2019 BISPL. All rights reserved.
//

import UIKit
import SwiftyJSON

class Recipe {
    
    var recipeName:String?
    var recipeIngredients:String?
    var recipeImgURL:String?
    var recipeLink:String?
    
    init(dict: [String : JSON]) {
        self.recipeName = dict["title"]?.stringValue
        self.recipeIngredients = dict["ingredients"]?.stringValue
        self.recipeImgURL = dict["thumbnail"]?.stringValue
        self.recipeLink = dict["href"]?.stringValue

    }

}
