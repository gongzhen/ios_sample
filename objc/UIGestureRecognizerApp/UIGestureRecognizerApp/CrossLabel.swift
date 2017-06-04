//
//  CrossLabel.swift
//  UIGestureRecognizerApp
//
//  Created by zhen gong on 6/3/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

class CrossLabel: BaseLabel {

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        _setup()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        _setup()
    }
    
    fileprivate func _setup() {
        self.text = "\u{2717}"
        self.textAlignment = .left
        self.translatesAutoresizingMaskIntoConstraints = false
    }
    
}
