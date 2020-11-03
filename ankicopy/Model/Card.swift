//
//  Card.swift
//  ankicopy
//
//  Created by user on 03.11.2020.
//

import UIKit

struct Card {
    var name: String
    var description: String
    var image: UIImage?
    init(name: String, description: String, image: UIImage?) {
        self.name = name
        self.description = description
        self.image = image
    }
}
