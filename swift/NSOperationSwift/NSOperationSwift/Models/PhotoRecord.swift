
//
//  PhotoRecord.swift
//  NSOperationSwift
//
//  Created by zhen gong on 6/30/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import Foundation
import UIKit

class PhotoRecord {
    let name: String
    let url:URL
    var state = PhotoRecordState.New
    var image = UIImage(named: "Placeholder")
    
    init(name:String, url:URL) {
        self.name = name
        self.url = url
    }
}
