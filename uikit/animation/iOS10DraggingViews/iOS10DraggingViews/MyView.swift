//
//  MyView.swift
//  iOS10DraggingViews
//
//  Created by zhen gong on 6/21/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

class MyView: UIView {

    var lastLocation = CGPoint(x: 0, y: 0)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let panRecognizer = UIPanGestureRecognizer(target: self, action: #selector(MyView.detectPan(_:)))
        self.gestureRecognizers = [panRecognizer]
        
        
        let blue = CGFloat(Int(arc4random_uniform(256) % 255)) / 255.0
        let green = CGFloat(Int(arc4random_uniform(256) % 255)) / 255.0
        let red = CGFloat(Int(arc4random_uniform(256) % 255)) / 255.0
        
        self.backgroundColor = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        
    }
    
    override func draw(_ rect: CGRect) {
        guard let currentContext = UIGraphicsGetCurrentContext() else {
            return
        }
        
        // pushes a copy of the current graphics state onto the graphic state stack for the context.
        currentContext.saveGState()
        
        // Creates a device-dependent RGB color space.
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let startColor = UIColor.red
        guard let startColorComponents = startColor.cgColor.components else {
            return
        }
        
        let endColor = UIColor.blue
        guard let endColorComponents = endColor.cgColor.components else { return }
        
        let colorComponents:[CGFloat] = [startColorComponents[0], startColorComponents[1], startColorComponents[2], startColorComponents[3], endColorComponents[0], endColorComponents[1], endColorComponents[2], endColorComponents[3]]
 
        // 6
        let locations:[CGFloat] = [0.0, 1.0]
        
        // 7
        guard let gradient = CGGradient(colorSpace: colorSpace,colorComponents: colorComponents,locations: locations,count: 2) else { return }
        
        let startPoint = CGPoint(x: 0, y: self.bounds.height)
        let endPoint = CGPoint(x: self.bounds.width,y: self.bounds.height)
        
        // 8
        currentContext.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
        
        // 9
        currentContext.restoreGState()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    func detectPan(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: self.superview)
        self.center = CGPoint(x:lastLocation.x + translation.x, y: lastLocation.y + translation.y)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.superview?.bringSubview(toFront: self)
        lastLocation = self.center
    }

}
