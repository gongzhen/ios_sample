//
//  Picture.swift
//  FlickrApp
//
//  Created by zhen gong on 6/15/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

struct Picture {
    
    let title: String
    let owner: String
    let url_q: String
    let url_z: String

    init(dictionary:[String: AnyObject]) {
        title = dictionary["title"] as! String
        owner = dictionary["owner"] as! String
        url_q = dictionary["url_q"] as! String
        url_z = dictionary["url_z"] as! String
    }
}
