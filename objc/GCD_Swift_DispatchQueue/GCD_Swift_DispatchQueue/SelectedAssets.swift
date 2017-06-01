//
//  SelectedAssets.swift
//  GCD_Swift_DispatchQueue
//
//  Created by zhen gong on 5/31/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit
import Photos

class SelectedAssets: NSObject {

    var assets: [PHAsset]
    
    override init() {
        assets = []
    }
    
    init(assets:[PHAsset]) {
        self.assets = assets
    }
}
