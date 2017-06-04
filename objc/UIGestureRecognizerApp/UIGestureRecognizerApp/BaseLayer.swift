
//
//  BaseLayer.swift
//  UIGestureRecognizerApp
//
//  Created by zhen gong on 6/3/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

class BaseLayer: CALayer {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
    }
    
    override init(layer: Any) {
        super.init(layer: layer)
        _setup()
    }
    
    private func _setup() {
        self.backgroundColor = UIColor(red: 0.0, green: 0.6, blue: 0.0, alpha: 1.0).cgColor
        self.isHidden = true
    }

}
