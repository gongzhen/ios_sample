//
//  ViewController.swift
//  iOS10DrawShapesTutorial
//
//  Created by zhen gong on 6/21/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var button1:UIButton?
    
    var button2:UIButton?
    
    var button3:UIButton?
    
    private func createButton(title:String, color:UIColor, tag:Int) -> UIButton {
        let button = UIButton(frame: CGRect.zero)
        button.titleLabel?.text = title
        button.titleLabel?.textColor = color
        button.backgroundColor = UIColor.red
        button.layer.cornerRadius = 1
        button.layer.masksToBounds = true
        button.tag = tag
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(buttonPressed), for: UIControlEvents.touchUpInside)
        
        return button
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        button1 = createButton(title: "Rectangle", color: UIColor.black, tag: 1)
        button2 = createButton(title: "Lines", color: UIColor.black, tag: 2)
        button3 = createButton(title: "Circle", color: UIColor.black, tag: 3)
        view.backgroundColor = UIColor.blue
        view.addSubview(button1!)
        view.addSubview(button2!)
        view.addSubview(button3!)
        let viewsDict:[String: UIView] = ["button1":button1!, "button2":button2!, "button3":button3!]
        
        let descHorizontal = "H:|-[button1(>=100)]-20-[button2(==button1)]-20-[button3(==button1)]-|"
        let descVertical1 = "V:|-100-[button1(40)]"
        let descVertical2 = "V:|-100-[button2(==button1)]"
        let descVertical3 = "V:|-100-[button3(==button1)]"
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: descHorizontal,
                                                                   options: NSLayoutFormatOptions(rawValue: 0),
                                                                   metrics: nil,
                                                                   views: viewsDict)
        let verticalConstraints1 = NSLayoutConstraint.constraints(withVisualFormat: descVertical1,
                                                                 options: NSLayoutFormatOptions(rawValue: 0),
                                                                 metrics: nil,
                                                                 views: viewsDict)
        let verticalConstraints2 = NSLayoutConstraint.constraints(withVisualFormat: descVertical2,
                                                                 options: NSLayoutFormatOptions(rawValue: 0),
                                                                 metrics: nil,
                                                                 views: viewsDict)
        let verticalConstraints3 = NSLayoutConstraint.constraints(withVisualFormat: descVertical3,
                                                                 options: NSLayoutFormatOptions(rawValue: 0),
                                                                 metrics: nil,
                                                                 views: viewsDict)
        self.view.addConstraints(horizontalConstraints)
        self.view.addConstraints(verticalConstraints1)
        self.view.addConstraints(verticalConstraints2)
        self.view.addConstraints(verticalConstraints3)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonPressed(_ sender: AnyObject) {
        
    }


}

