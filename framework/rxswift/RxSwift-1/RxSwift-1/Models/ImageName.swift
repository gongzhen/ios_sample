//
//  ImageName.swift
//  RxSwift-1
//
//  Created by ULS on 4/3/18.
//  Copyright © 2018 ULS. All rights reserved.
//

import UIKit

enum ImageName: String {
    case
    Amex,
    Discover,
    Mastercard,
    Visa,
    UnknownCard
    
    var image: UIImage {
        guard let image = UIImage(named: self.rawValue) else {
            fatalError("Image not found for name \(self.rawValue)")
        }
        
        return image
    }
}
