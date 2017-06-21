//
//  ShapeView.swift
//  iOS10DrawShapesTutorial
//
//  Created by zhen gong on 6/21/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

class ShapeView: UIView {

    var currentShapeType: Int = 0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented.")
    }
    
    init(frame:CGRect, shape:Int) {
        super.init(frame: frame)
        self.currentShapeType = shape
    }
    
    override func draw(_ rect: CGRect) {
        switch currentShapeType {
        case 0: drawRectangle()
        case 1: drawLines()
        case 2: drawCircle()
        default: print("default")
        }
    }
    
    func drawLines() {
        //1
        guard let ctx = UIGraphicsGetCurrentContext() else { return }
        
        //2
        ctx.beginPath()
        ctx.move(to: CGPoint(x: 20.0, y: 20.0))
        ctx.addLine(to: CGPoint(x: 250.0, y: 100.0))
        ctx.addLine(to: CGPoint(x: 100.0, y: 200.0))
        ctx.setLineWidth(5)
        
        //3
        ctx.closePath()
        ctx.strokePath()
    }
    
    func drawRectangle() {
    
    }
    
    func drawCircle() {
    
    }
    
    
    
}
