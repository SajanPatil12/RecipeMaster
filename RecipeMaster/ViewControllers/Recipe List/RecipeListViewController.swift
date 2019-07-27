//
//  ViewController.swift
//  RecipeMaster
//
//  Created by sajan on 23/07/19.
//  Copyright © 2019 BISPL. All rights reserved.
//

import UIKit
import SVProgressHUD
import SDWebImage

class RecipeListViewController: UIViewController,UISearchResultsUpdating,UIScrollViewDelegate{

    @IBOutlet weak var searchContainerView: UIView!
    @IBOutlet weak var recipeTableView: UITableView!
    var searchController:UISearchController!

    let cellIdentifier = "RecipeListCell"
    var recipeListArray:[Recipe] = []
    var recipeListFilteredArray:[Recipe] = []

    private var currentPage = 1
    private var shouldShowLoadingCell = false

    lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:
            #selector(self.handleRefresh(_:)),
                                 for: UIControl.Event.valueChanged)
        refreshControl.tintColor = UIColor.white
        return refreshControl
    }()

    // MARK: -

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureSearchController()
        self.configureRecipeTableView()
        self.loadMyListApiCallFunc()
    }
    
    func configureSearchController() {
        
        searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.sizeToFit()
        definesPresentationContext = true
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.barTintColor = UIColor.darkGray
        searchController.searchBar.tintColor = UIColor.white
        self.searchContainerView.addSubview(searchController.searchBar)
    }
    
    func configureRecipeTableView() {
        
        recipeTableView.backgroundView = UIImageView(image: UIImage(named: "backgroud_img"))
        recipeTableView.refreshControl = refreshControl
        recipeTableView.rowHeight = UITableView.automaticDimension
        recipeTableView.estimatedRowHeight = 110
    }
    
    // MARK: - Webservice
    
    func loadMyListApiCallFunc() {
        
        SVProgressHUD.show()
        let apiObj = ApiHandler()
        apiObj.getData(url: "http://www.recipepuppy.com/api/?p=\(currentPage)") { (json, status) in
            
            print("Response : \(json)")
            if status
            {
                let recipeArray = json["results"].arrayValue
                
                if recipeArray.count > 0 {
                    
                    for (_, recipeDict) in recipeArray.enumerated() {
                        let recipeObj = Recipe(dict:recipeDict.dictionary!)
                        self.recipeListArray.append(recipeObj)
                    }
                    self.recipeListFilteredArray = self.recipeListArray

                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                        self.recipeTableView.reloadData()
                    }
                }
                else {
                    //Display msg
                    DispatchQueue.main.async {
                        SVProgressHUD.dismiss()
                    }
                }
            }
            else
            {
                //Display msg
                DispatchQueue.main.async {
                    SVProgressHUD.dismiss()
                }
            }
        }
    }
    
    // MARK: - UISearch result update delegate
    
    func updateSearchResults(for searchController: UISearchController) {
        
        if let searchText = self.searchController.searchBar.text {

            self.recipeListFilteredArray = searchText.isEmpty ? self.recipeListArray : self.recipeListArray.filter {
                    return $0.recipeIngredients!.lowercased().range(of: searchText.lowercased()) != nil || $0.recipeName!.range(of: searchText) != nil
                }
            }
        self.recipeTableView.reloadData()
    }
    
    // MARK: - Scroll Pagination

    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        //Bottom Refresh
        if scrollView == self.recipeTableView{
            
            if ((scrollView.contentOffset.y + scrollView.frame.size.height) >= scrollView.contentSize.height)
            {
                self.currentPage += 1
                self.loadMyListApiCallFunc()
            }
        }
    }
    
    // MARK: - Pull to refresh

    @objc func handleRefresh(_ refreshControl: UIRefreshControl) {
        
        currentPage = 1
        self.recipeListArray.removeAll()
        self.loadMyListApiCallFunc()
        refreshControl.endRefreshing()
    }

}

extension RecipeListViewController: UITableViewDataSource,UITableViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recipeListFilteredArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let recipeCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! RecipeListCell
        
        recipeCell.contentView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.6)
        recipeCell.containerView.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.5)
        recipeCell.containerView.layer.cornerRadius = 10
        recipeCell.containerView.layer.shadowColor = UIColor.black.cgColor
        recipeCell.containerView.layer.shadowOpacity = 0.3
        recipeCell.containerView.layer.shadowOffset = .zero
        recipeCell.containerView.layer.shadowRadius = 4
        
        let recipe:Recipe = self.recipeListFilteredArray[indexPath.row]
        
        recipeCell.reciprTitleLbl.text = recipe.recipeName
        recipeCell.recipeDetailsLbl.text = recipe.recipeIngredients
        recipeCell.recipeImgView.sd_setImage(with: URL(string:recipe.recipeImgURL!), placeholderImage: UIImage(named: "recipe_placeholder"))
        
        return recipeCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let recipeDetailsVC = storyboard.instantiateViewController(withIdentifier: "RecipeDetailViewController") as! RecipeDetailViewController
        recipeDetailsVC.recipeDetails = self.recipeListFilteredArray[indexPath.row]
        self.navigationController?.pushViewController(recipeDetailsVC, animated: true)
    }

}
