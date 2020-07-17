//
//  NetworkHandler.swift
//  TeachOnMarsPictures
//
//  Created by Sabrine Rouis on 22/06/2020.
//  Copyright © 2020 Sabrine Rouis. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

/// handle networking to load data for the model
class NetWorkHandler {
    
    // network errors enumeration
    enum APIError: Error {
         case decodeFailure
         case badAPI
     }

    
    static var dataURL: String = "https://dev1-userdata.teachonmars.com/mobile-data"
    var picturesURL: String = "\(dataURL)/pictures.json"
    var categoriesURL: String = "\(dataURL)/categories.json"
    
    var categories = [Category]()
    var pictures = [Picture]()
        
    /// Retrieve the list of categories
    func retrieveCategories(completionHandler: @escaping (Result<[Category], APIError>) -> Void) {
        AF.request(self.categoriesURL).responseJSON { response in
            switch response.result {
            case .success:
                let decoder = JSONDecoder()
                guard let jsonData = response.data else {
                    completionHandler(.failure(.decodeFailure))
                    return
                }
                do {
                    let categories = try decoder.decode([Category].self, from: jsonData)
                    print("categories?: \(categories.count)")
                    self.categories = categories
                    completionHandler(.success(categories))
                } catch let parsingError {
                    print("Error", parsingError)
                    completionHandler(.failure(.decodeFailure))
                }
            case let .failure(error):
                print(error)
                completionHandler(.failure(.badAPI))
            }
        }
    }
    
    /// Retrieve the list of pictures
    func retrievePictures(completionHandler: @escaping (Result<[Picture], APIError>) -> Void) {
        AF.request(self.picturesURL).responseJSON { response in
            switch response.result {
            case .success:
                let decoder = JSONDecoder()
                guard let jsonData = response.data else {
                    completionHandler(.failure(.decodeFailure))
                    return
                }
                do {
                    let pictures = try decoder.decode([Picture].self, from: jsonData)
                    print("Pictures?: \(pictures.count)")
                    self.pictures = pictures
                    completionHandler(.success(pictures))
                } catch let parsingError {
                    print("Error", parsingError)
                    completionHandler(.failure(.decodeFailure))
                }
            case let .failure(error):
                print(error)
                completionHandler(.failure(.badAPI))
            }
        }
    }
}
