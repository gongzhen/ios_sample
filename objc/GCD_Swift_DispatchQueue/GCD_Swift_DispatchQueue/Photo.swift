//
//  Photo.swift
//  GCD_Swift_DispatchQueue
//
//  Created by zhen gong on 5/31/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

protocol Photo {
    var statusImage: PhotoStatus { get }
    var statusThumbnail: PhotoStatus { get }
    var image: UIImage? { get }
    var thumbnail: UIImage? { get }
}
