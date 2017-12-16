//
//  ProfileModel.swift
//  TableViewMultipleCellMVVMSwift
//
//  Created by Admin  on 9/25/17.
//  Copyright © 2017 Admin . All rights reserved.
//

import Foundation

public func dataFromFile(_ filename: String) -> Data? {
    let bundle = Bundle.main
    
    if let path = bundle.path(forResource: filename, ofType: "json") {
        return (try? Data(contentsOf: URL(fileURLWithPath: path)))
    }
    return nil
}

class Friend {
    var name: String?
    var pictureUrl:String?
    
    init(json:[String:Any]) {
        self.name = json["name"] as? String
        self.pictureUrl = json["pictureUrl"] as? String
    }
}

class Attribute: NSObject {
    var key: String?
    var value: String?
    
    init(json:[String: Any]) {
        self.key = json["key"] as? String
        self.value = json["value"] as? String
    }
}
