//
//  PicturesPagingViewController.swift
//  TeachOnMarsPictures
//
//  Created by Sabrine Rouis on 22/06/2020.
//  Copyright © 2020 Sabrine Rouis. All rights reserved.
//

import UIKit

/// Add paging to allow swiping between detailed pictures
class PagingPicturesViewController: UIPageViewController, UIPageViewControllerDelegate {
    
    // MARK: Properties
    var pictures = [Picture]()
    var currentIndex: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let viewController = viewDetailedPictureController(currentIndex ?? 0) {
            let viewControllers = [viewController]
            
            setViewControllers(viewControllers,
                               direction: .forward,
                               animated: false,
                               completion: nil)
        }
        
        navigationItem.title = pictures[currentIndex].title
        dataSource = self
        delegate = self
    }
    
    /// define the view page to display on swiping (paging)
    /// - Parameter: index of the picture in the list
    func viewDetailedPictureController(_ index: Int) -> DetailedPictureViewController? {
        guard
            let storyboard = storyboard,
            let page = storyboard.instantiateViewController(withIdentifier: "DetailedPictureViewController") as? DetailedPictureViewController
            else {
                return nil
        }
        if ((pictures.count == 0) || (index >= pictures.count)) {
            return nil
        }
        
        page.selectedPicture = pictures[index]
        page.pictureIndex = index
        
        return page
    }
    
}
    // MARK: - UIPageViewControllerDataSource
extension PagingPicturesViewController : UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // retrieve current picture index
        var index = (viewController as! DetailedPictureViewController).pictureIndex
        
        if index == NSNotFound {
            return nil
        }
        // update the navigation title with the previous item
        navigationItem.title = pictures[index].title
        
        if index == 0 { return nil }
        
        // back to previous index
        index -= 1
        return viewDetailedPictureController(index)
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // retrieve current picture index
        var index = (viewController as! DetailedPictureViewController).pictureIndex
        
        if index == NSNotFound {
            return nil
        }
        // update the navigation title with the next item
        navigationItem.title = pictures[index].title
        // go next index
        index += 1
        
        // do not allow infinite swiping
        if index == pictures.count { return nil }
        
        return viewDetailedPictureController(index)
        
    }
}
