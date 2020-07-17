//
//  PictureCollectionViewCell.swift
//  TeachOnMarsPictures
//
//  Created by Sabrine Rouis on 22/06/2020.
//  Copyright © 2020 Sabrine Rouis. All rights reserved.
//

import UIKit

class PictureCollectionViewCell: UICollectionViewCell {
    
    // Mark: Properties
    @IBOutlet weak var pictureImageView: UIImageView!
    
    @IBOutlet weak var widthConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        // add some shadow to the cell
        clipsToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = .zero
        layer.shadowRadius = 5
        layer.shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: 2).cgPath
        
        // round the picture corner
        pictureImageView.layer.cornerRadius =  5.0
        pictureImageView.layer.masksToBounds = true
        
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // fit the image to the cell width/height
        widthConstraint.constant = contentView.bounds.width
        heightConstraint.constant = contentView.bounds.height
    }
}
