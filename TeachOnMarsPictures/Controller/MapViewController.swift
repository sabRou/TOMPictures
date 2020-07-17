//
//  MapViewController.swift
//  TeachOnMarsPictures
//
//  Created by Sabrine Rouis on 23/06/2020.
//  Copyright © 2020 Sabrine Rouis. All rights reserved.
//

import UIKit
import MapKit

/// Display the pictures list on map view with market and callout
class MapViewController: UIViewController {
    
    // MARK: - Properties
    
    @IBOutlet private var mapView: MKMapView!
    private var pictures: [Picture] = []
    private var pins: [PictureAnnotation] = []
    private let network = NetWorkHandler()
    var selectedPictureIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // map View
        mapView.delegate = self
        mapView.showsUserLocation = true
        mapView.register(PictureMapMarkerView.self,
                         forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        // load pictures
        retrievePictures()
        
    }
    
    /// retrieve the list of pictures from network
    /// load and add the annotations pin for each picture on the map
    func retrievePictures() {
        network.retrievePictures() { result in
            switch result {
            case .success(let pictures):
                self.pictures = pictures
                self.pins = pictures.map({PictureAnnotation(from:$0)})
                self.mapView.addAnnotations(self.pins)
            case .failure(let error):
                print(error)
                
            }
        }
    }
    
    
    
    // MARK: - Navigation
    
    /// Prepare next view, here we need to send pictures list sorted by distance
    /// - Parameter segue:
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        switch (segue.identifier ?? "") {
        case "ShowPictureFromMap":
            guard let detailedPictureViewController = segue.destination as? PagingPicturesViewController else {
                fatalError("Unexpected destination: \(segue.destination)")
            }
            
            // re-order next photos by distance from the selected one
            let selectedLocation = CLLocation(latitude: pins[selectedPictureIndex].coordinate.latitude, longitude: pins[selectedPictureIndex].coordinate.longitude)
            
            var sortedPictures = pictures
            // put the selected picture at first
            sortedPictures.swapAt(0, selectedPictureIndex)
            // then sort by location
            sortedPictures.sort(by: {
                guard let loc1 = $0.location, let loc2 = $1.location else {return false }
                return loc1.distance(from: selectedLocation) < loc2.distance(from: selectedLocation)
            })
            // finally pass sorted pictures to next view
            detailedPictureViewController.pictures = sortedPictures
            detailedPictureViewController.currentIndex = 0
            
        default:
            fatalError("Unexpected Segue Identifier; \(String(describing: segue.identifier))")
        }
        
    }
    
    
}

// MARK: - MKMapView Delegate

extension MapViewController: MKMapViewDelegate {
    func mapView(
        _ mapView: MKMapView,
        annotationView view: MKAnnotationView,
        calloutAccessoryControlTapped control: UIControl
    ) {
        guard let pic = view.annotation as? PictureAnnotation else {
            return
        }
        // on callout tap go to next view, the detailed picture
        selectedPictureIndex = pins.firstIndex(of: pic) ?? 0
        performSegue(withIdentifier: "ShowPictureFromMap", sender: self)
    }
}
