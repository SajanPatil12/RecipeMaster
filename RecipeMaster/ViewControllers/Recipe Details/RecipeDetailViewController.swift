//
//  RecipeDetailViewController.swift
//  RecipeMaster
//
//  Created by sajan on 23/07/19.
//  Copyright © 2019 BISPL. All rights reserved.
//

import UIKit
import Toast_Swift

class RecipeDetailViewController: UIViewController {

    @IBOutlet weak var recipeNameLbl: UILabel!
    @IBOutlet weak var recipeImgView: UIImageView!
    @IBOutlet weak var recipeIngredientsLbl: UILabel!
    
    var recipeDetails:Recipe?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.updateUI()
    }
    
    // MARK: - IBActions

    @IBAction func actionBackBtnTapped(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func actionShareBtnTapped(_ sender: Any) {
        
        let recipeName = self.recipeDetails?.recipeName
        let recipeLink : NSURL = NSURL(string: self.recipeDetails!.recipeLink!)!
        let image : UIImage = self.recipeImgView.image!

        let activityVC = UIActivityViewController(activityItems: [recipeName!,"\nCheck out this Recipe!",recipeLink,image], applicationActivities: nil)
        activityVC.popoverPresentationController?.sourceView = self.view
        self.present(activityVC, animated: true, completion:nil)

        activityVC.completionWithItemsHandler = { activity, success, items, error in
            if success{
                self.view.makeToast("Shared", duration: 2.0, position: .bottom)
            }
        }

    }
    
    func updateUI() {
        self.recipeNameLbl.text = recipeDetails?.recipeName
        self.recipeIngredientsLbl.text = recipeDetails?.recipeIngredients
        self.recipeImgView.sd_setImage(with: URL(string:recipeDetails!.recipeImgURL!), placeholderImage: UIImage(named: "recipe_placeholder"))
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
