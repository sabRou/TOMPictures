//
//  FullPictureViewController.swift
//  TeachOnMarsPictures
//
//  Created by Sabrine Rouis on 23/06/2020.
//  Copyright © 2020 Sabrine Rouis. All rights reserved.
//

import UIKit

/// Display the picture with fullScreen on double tap
class FullPictureViewController: UIViewController {
    
    @IBOutlet weak var fullImageView: UIImageView!
    var imageUrl: URL?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let url = imageUrl {
            //load image
            fullImageView.kf.setImage(with: url, placeholder: UIImage(named:"imageNotAvailable")) {
                result in
                if (try? result.get()) != nil {
                    // Do some spring animation (just for fun!)
                    self.fullImageView.transform = CGAffineTransform(scaleX: 0, y: 0)
                    UIView.animate(withDuration: 0.3, delay: 0.5,usingSpringWithDamping: 0.8, initialSpringVelocity: 0,  options: [.curveEaseIn], animations: {
                        self.fullImageView.transform  = .identity
                    })
                }
            }
        }
    }
    
    
    /// Tap gesture Action to close the modal
    /// support double tap to dismiss
    /// animate the dismiss with fadeout
    @IBAction func tapGestureActionToClose(_ sender: UITapGestureRecognizer) {
        UIView.animate(withDuration: 0.3, delay: 0,options: [.curveEaseOut],  animations: {
            self.fullImageView.alpha = 0
        }, completion: { finished in
            self.dismiss(animated: true, completion: nil)
        })
    }
}
