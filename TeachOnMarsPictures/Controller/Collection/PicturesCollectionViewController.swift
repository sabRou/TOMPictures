//
//  PicturesCollectionViewController.swift
//  TeachOnMarsPictures
//
//  Created by Sabrine Rouis on 22/06/2020.
//  Copyright © 2020 Sabrine Rouis. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher



class PicturesCollectionViewController: UICollectionViewController {
    
    // MARK: - Properties
    
    private let reuseIdentifier = "PictureCollectionViewCell"
    var pictures = [Picture]()
    private let network = NetWorkHandler()
    
    private let itemsPerRow: CGFloat = 3
    private let sectionInsets = UIEdgeInsets(top: 30.0, left: 20.0, bottom: 30.0, right: 20.0)
    
    // MARK: - View life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // load photos
        retrievePictures()
    }
    
    func retrievePictures() {
        network.retrievePictures() { result in
            switch result {
            case .success(let pictures):
                self.pictures = pictures
                self.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    // MARK: - Navigation
    
    /// Some preparation before next navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch (segue.identifier ?? "") {
        case "ShowPictureFromGrid":
            guard let detailedPictureViewController = segue.destination as? PagingPicturesViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            guard let selectedPictureCell = sender as? PictureCollectionViewCell else {
                fatalError("Unexpected sender: \(String(describing: sender))")
            }
            guard let indexPath = collectionView.indexPath(for: selectedPictureCell) else {
                fatalError("The selected cell is not being displayed by the table")
            }
            // pass pictures list
            detailedPictureViewController.currentIndex = indexPath.row
            detailedPictureViewController.pictures = pictures
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
        
    }
    
    
    // MARK: - UICollectionView DataSource
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pictures.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Configure the cell
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? PictureCollectionViewCell  else {
            fatalError("The dequeued cell is not an instance of PictureCollectionViewCell.")
        }
        
        let picture = pictures[indexPath.row]
        if let url = picture.imageUrl {
            cell.pictureImageView.kf.setImage(with: url, placeholder: UIImage(named:"imageNotAvailable"))
        }
        
        return cell
    }
}

// MARK: -  Collection View Flow Layout Delegate

extension PicturesCollectionViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        //size of the given cell
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    // spacing between the cells
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    // spacing between each line
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
}
