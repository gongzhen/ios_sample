//
//  StrikeThroughTextLabel.swift
//  UIGestureRecognizerApp
//
//  Created by zhen gong on 6/3/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

class StrikeThroughTextLabel: UILabel {
    
    var strikeThroughLayer: CALayer
    
    var strikeThrough:Bool {
        didSet {
            strikeThroughLayer.isHidden = !strikeThrough
            if strikeThrough {
                _resizeStrikeThrough()
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        strikeThroughLayer = CALayer()
        strikeThroughLayer.backgroundColor = UIColor.white.cgColor
        strikeThroughLayer.isHidden = true
        strikeThrough = false
        super.init(coder: aDecoder)
        // _setup()
        self.layer.addSublayer(strikeThroughLayer)
        _setup()
    }
    
    override init(frame: CGRect) {
        strikeThroughLayer = CALayer()
        strikeThroughLayer.backgroundColor = UIColor.white.cgColor
        strikeThroughLayer.isHidden = true
        strikeThrough = false
        super.init(frame: frame)
        self.layer.addSublayer(strikeThroughLayer)
        _setup()
    }
    
    private func _setup() {
        self.textColor = UIColor.white
        self.font = UIFont.boldSystemFont(ofSize: 16)
        self.backgroundColor = UIColor.clear
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        _resizeStrikeThrough()
    }
    
    fileprivate func _resizeStrikeThrough() {
        let textSize = text!.size(attributes: [NSFontAttributeName:font])
        strikeThroughLayer.frame = CGRect(x: 0,
                                          y: bounds.size.height/2,
                                          width: textSize.width,
                                          height: LayoutConstant.kStrikeOutThickness)
    }

}
