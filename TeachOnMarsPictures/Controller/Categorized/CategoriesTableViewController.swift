//
//  CategoriesTableViewController.swift
//  TeachOnMarsPictures
//
//  Created by Sabrine Rouis on 22/06/2020.
//  Copyright © 2020 Sabrine Rouis. All rights reserved.
//

import UIKit
import Alamofire

class CategoriesTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var categories = [Category]()
    private let network = NetWorkHandler()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // retrieve the categories from network
        network.retrieveCategories() { result in
            switch result {
            case .success(let categories):
                self.categories = categories
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Estimate the row height and make the dimension automatic so the row can fit the long text
        tableView.estimatedRowHeight = 90
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categories.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cellIdentifier = "CategoryTableViewCell"
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CategoryTableViewCell  else {
            fatalError("The dequeued cell is not an instance of CategoryTableViewCell.")
        }
        // Configure the cell...
        let category = categories[indexPath.row]
        cell.titleLabel.text = category.title
        cell.descriptionLabel.text = category.description.en
        
        return cell
    }
    
    
    // MARK: - Navigation
    
    /// Do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        switch (segue.identifier ?? "") {
        case "ShowPicturesList":
            guard let picturesTableViewController = segue.destination as? PicturesTableViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedCategoryCell = sender as? CategoryTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            
            guard let indexPath = tableView.indexPath(for: selectedCategoryCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            // pass selected category
            let selectedCategory = categories[indexPath.row]
            picturesTableViewController.selectedCategory = selectedCategory
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
}
