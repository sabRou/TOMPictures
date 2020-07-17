//
//  Category.swift
//  TeachOnMarsPictures
//
//  Created by Sabrine Rouis on 22/06/2020.
//  Copyright © 2020 Sabrine Rouis. All rights reserved.
//

import Foundation
import UIKit

struct Category : Codable {
    let title: String
    let position: Int
    let description: Description
    let id: String
}

struct Description: Codable {
    let fr: String
    let en: String
}
