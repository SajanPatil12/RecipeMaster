//
//  RecipeMasterTests.swift
//  RecipeMasterTests
//
//  Created by sajan on 23/07/19.
//  Copyright © 2019 BISPL. All rights reserved.
//
import UIKit
import XCTest
@testable import RecipeMaster

class RecipeMasterTests: XCTestCase {
    
    var recipeListViewController: RecipeListViewController!

    override func setUp() {
        super.setUp()

        // Put setup code here. This method is called before the invocation of each test method in the class.
        recipeListViewController = RecipeListViewController()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        recipeListViewController = nil
        super.tearDown()
    }

    func test_CanInstantiate_ViewController() {
        
        XCTAssertNotNil(recipeListViewController)
    }
    
    func test_ControllerHas_TableView() {
        
        recipeListViewController.loadViewIfNeeded()
        XCTAssertNotNil(recipeListViewController.recipeTableView,
                        "Controller should have a tableview")
    }
    
    func test_ConformsToTableviewViewDataSource() {
    XCTAssertTrue(recipeListViewController.responds(to:(#selector(recipeListViewController.tableView(_:numberOfRowsInSection:)))))
    XCTAssertTrue(recipeListViewController.responds(to:(#selector(recipeListViewController.tableView(_:cellForRowAt:)))))
        
    }
    
    func test_TableViewCellHasReuseIdentifier() {
        recipeListViewController.loadViewIfNeeded()
        let cell = recipeListViewController.tableView(recipeListViewController.recipeTableView, cellForRowAt: IndexPath(row: 0, section: 0)) as? RecipeListCell
        let actualReuseIdentifer = cell?.reuseIdentifier
        let expectedReuseIdentifier = "RecipeListCell"
        XCTAssertEqual(actualReuseIdentifer, expectedReuseIdentifier)
    }
    
    func test_get_data_withURL() {
        
        let apiHandler = ApiHandler()
        
        apiHandler.getData(url: "http://www.recipepuppy.com/api/?p=1") { (JSON, status) in
            
            XCTAssertEqual(status,true,"success")
            
        }
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
