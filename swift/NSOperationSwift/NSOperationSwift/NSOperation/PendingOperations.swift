//
//  PendingOperations.swift
//  NSOperationSwift
//
//  Created by zhen gong on 6/30/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import Foundation

class PendingOperations{
    
    var map:[String: Int] = [String: Int]()
    
    func updateMap(key:String) {
        if let value = map[key] {
            map.updateValue(value + 1, forKey: key)
        } else {
            map.updateValue(1, forKey: key)
        }
    }
    
    
//    var map:[String: Int]? {
//        willSet {
//        
//        }
//        didSet {
//        
//        }
//    }
//    
    lazy var downloadsInProgress = [IndexPath:Operation]()
    lazy var downloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Download queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    lazy var filtrationsInProgress = [IndexPath:Operation]()
    lazy var filtrationQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "Image Filtration queue"
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
}

