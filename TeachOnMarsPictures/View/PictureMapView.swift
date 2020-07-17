//
//  PictureMapView.swift
//  TeachOnMarsPictures
//
//  Created by Sabrine Rouis on 23/06/2020.
//  Copyright © 2020 Sabrine Rouis. All rights reserved.
//

import MapKit
import Kingfisher

class PictureMapMarkerView: MKMarkerAnnotationView {
    
    override var annotation: MKAnnotation? {
        willSet {            
            guard let picture = newValue as? PictureAnnotation else {
                return
            }
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            
            // design the callout with label and button
            let mapsButton = UIButton(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 48, height: 48)))
            mapsButton.setBackgroundImage(#imageLiteral(resourceName: "imageNotAvailable"), for: .normal)
            
            // picture description in the label
            let detailLabel = UILabel()
            detailLabel.numberOfLines = 0
            detailLabel.font = detailLabel.font.withSize(12)
            detailLabel.text = picture.info
            
            // get the picture as background image for the button
            if let url = picture.imageURL {
                KingfisherManager.shared.retrieveImage(with: url) { result in
                    if let value = try? result.get() {
                        mapsButton.setBackgroundImage(value.image, for: .normal)
                    }
                }
            }
            
            detailCalloutAccessoryView = detailLabel
            rightCalloutAccessoryView = mapsButton
        }
    }
}
