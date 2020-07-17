//
//  PicturesTableViewController.swift
//  TeachOnMarsPictures
//
//  Created by Sabrine Rouis on 22/06/2020.
//  Copyright © 2020 Sabrine Rouis. All rights reserved.
//

import UIKit

class PicturesTableViewController: UITableViewController {
    
    // MARK: - Properties
    
    var selectedCategory: Category?
    var pictures = [Picture]()
    private let network = NetWorkHandler()
    @IBOutlet weak var sortBn: UIBarButtonItem!
    @IBOutlet weak var editBn: UIBarButtonItem!
    let searchController = UISearchController(searchResultsController: nil)
    var defaultPictures = [Picture]()
    
     // MARK: - View life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // retrieve pictures from network
            network.retrievePictures() { result in
                if let gotPictures = try? result.get() {
                    self.pictures = gotPictures.filter { ($0.category == self.selectedCategory?.id) }
                    self.defaultPictures = self.pictures
                    self.tableView.reloadData()
                }
            }
        
 
        sortBn.accessibilityHint = "Sort pictures by name"
        
        // Search Controller:
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        searchController.searchBar.accessibilityHint = "Search picture by name"
        searchController.searchBar.delegate = self
        searchController.searchResultsUpdater = self
        
        navigationItem.searchController = searchController
        definesPresentationContext = true
        navigationItem.leftItemsSupplementBackButton = true
        navigationItem.title = selectedCategory?.title
        
    }
    
    // MARK: - Actions
    
    /// Action button to enable editing tableView and reordering the items
    @IBAction func reorderAction(_ sender: Any) {
        tableView.isEditing  = !tableView.isEditing
        editBn.title = tableView.isEditing ? "Done" : "Order"
    }
    
    /// Action button to sort items names alphabetically
    @IBAction func sortAction(_ sender: Any) {
        if(pictures.count > 2 && pictures[0].title.compare(pictures[1].title) == .orderedAscending) {
            pictures.sort(by: {
                $0.title > $1.title
            })
        } else {
            pictures.sort(by: {
                $0.title < $1.title
            })
        }
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "PictureTableViewCell", for: indexPath) as? PictureTableViewCell else {
            fatalError("The dequeued cell is not an instance of PictureTableViewCell.")
        }
        // Configure the cell
        let picture = pictures[indexPath.row]
        cell.titleLabel.text = picture.title
        cell.dateLabel.text = picture.dateText
        if let url = picture.imageUrl {
            //load image
            cell.pictureImageView.kf.setImage(with: url, placeholder: UIImage(named:"imageNotAvailable"))
        }
        
        return cell
    }
    
    
    /// Support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = pictures[sourceIndexPath.row]
        pictures.remove(at: sourceIndexPath.row)
        pictures.insert(movedObject, at: destinationIndexPath.row)
        defaultPictures = pictures
    }
    
    
    
    /// Support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    /// Update editing stype to none (hide delete buttons)
    override func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }
    
    override func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }
    
    
    // MARK: - Navigation
    
    /// Doing  little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch (segue.identifier ?? "") {
        case "ShowPictureFromList":
            guard let detailedPictureViewController = segue.destination as? PagingPicturesViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedPictureCell = sender as? PictureTableViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = tableView.indexPath(for: selectedPictureCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            // Pass the list of categorized pictures to the new view controller.
            detailedPictureViewController.currentIndex = indexPath.row
            detailedPictureViewController.pictures = defaultPictures
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
    }
}

 // MARK: - UISearchResults Updating

extension PicturesTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        // reload tableView when search text is empty
        if(searchController.searchBar.text?.isEmpty ?? true) {
            pictures = defaultPictures
            tableView.reloadData()
        }
    }
}

// MARK: - UISearchBar Delegate

extension PicturesTableViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // filter pictures by the search text
        let searchText = searchText.lowercased()
        let filtered = pictures.filter({ $0.title.lowercased().contains(searchText) })
        self.pictures = filtered.isEmpty ? pictures : filtered
        tableView.reloadData()
    }
}
