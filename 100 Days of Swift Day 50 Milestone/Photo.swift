//
//  Photo.swift
//  100 Days of Swift Day 50 Milestone
//
//  Created by Seb Vidal on 12/12/2021.
//

import Foundation
import UIKit

class Photo: NSObject, Codable {
    
    var image: String
    var label: String
    
    init(image: String, label: String) {
        self.image = image
        self.label = label
    }
    
    required init(coder: NSCoder) {
        image = coder.decodeObject(forKey: "image") as? String ?? ""
        label = coder.decodeObject(forKey: "label") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(image, forKey: "image")
        coder.encode(label, forKey: "label")
    }
    
}
