//
//  Picture.swift
//  TeachOnMarsPictures
//
//  Created by Sabrine Rouis on 22/06/2020.
//  Copyright © 2020 Sabrine Rouis. All rights reserved.
//

import Foundation
import UIKit
import MapKit


struct Picture : Codable {
    //MARK -: Properties
    
    let id: String
    let title: String
    let position: Int
    let description: String
    let imagePath: String?
    let email: String?
    let author: String
    let latitude: Double?
    let longitude: Double?
    let category: String
    let date: String?
    
    /// get the date in readable text format
    var dateText: String {
        get {
            let date = self.date ?? ""
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
            if let formatedDate = formatter.date(from: date) {
                formatter.dateFormat = "MMMM d, yyyy  HH:mm a"
                return formatter.string(from: formatedDate)
            }
            return date
        }
    }
    
    /// get the image url
    var imageUrl: URL? {
        get {
            if let path = self.imagePath {
                let fullPath: String = "\(NetWorkHandler.dataURL)/\(path)"
                if let url = URL(string: fullPath) {
                    return url
                }
            }
            return nil
        }
    }
    /// location from latitude and longitude
    var location: CLLocation? {
        guard let lat = latitude, let long = longitude else {
            return nil
        }
        return CLLocation(latitude: lat, longitude: long)
    }
}



/// Picture annotation on mapView
class PictureAnnotation: NSObject, MKAnnotation {
    var title: String?
    var coordinate: CLLocationCoordinate2D
    var info: String?
    var imageURL: URL?
    
    init(title: String?, info: String?, coordinate: CLLocationCoordinate2D){
        self.title = title
        self.info = info
        self.coordinate = coordinate
        
        super.init()
    }
    
    /// init the annotation from a Picture
    /// - Parameter Picture:
    init(from picture: Picture) {
        self.title = picture.title
        self.info = picture.description
        self.imageURL = picture.imageUrl
        
        if let lat = picture.latitude, let long = picture.longitude {
            self.coordinate = CLLocationCoordinate2D(latitude: lat,
                                                     longitude: long)
        } else {
            // Default coordinate will be from Biot, France
            self.coordinate = CLLocationCoordinate2D(latitude: 43.6333, longitude: 7.1)
        }
        
        super.init()
    }
    /// get the map item (to be open in maps if needed)
    var mapItem: MKMapItem? {
        let placemark = MKPlacemark(
            coordinate: coordinate,
            addressDictionary: nil)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = title
        return mapItem
    }
}

