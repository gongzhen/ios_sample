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
    
    var myView:UIView?
    
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
    
    private func createView() -> UIView {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.cyan
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        button1 = createButton(title: "Rectangle", color: UIColor.black, tag: 1)
        button2 = createButton(title: "Lines", color: UIColor.black, tag: 2)
        button3 = createButton(title: "Circle", color: UIColor.black, tag: 3)
        myView = createView()
        view.backgroundColor = UIColor.white
        
        view.addSubview(button1!)
        view.addSubview(button2!)
        view.addSubview(button3!)
        view.addSubview(myView!)
        
        let horizontalSpacing = 20
        let verticalSpacing = 100
        let viewVerticalSpace = 10
        let cornerMargin = 10
        let viewsDict:[String: UIView] = ["button1":button1!, "button2":button2!, "button3":button3!, "myView":myView!]
        let metrics = ["horizontalSpacing" : horizontalSpacing, "cornerMargin": cornerMargin, "verticalSpacing":verticalSpacing, "viewVerticalSpace":viewVerticalSpace]
        let descHorizontal = "H:|-(==cornerMargin)-[button1(>=100)]-horizontalSpacing-[button2(==button1)]-horizontalSpacing-[button3(==button1)]-(==cornerMargin)-|"
        let descVertical1 = "V:|-(==verticalSpacing)-[button1]"
        let descVertical2 = "V:|-(==verticalSpacing)-[button2]"
        let descVertical3 = "V:|-(==verticalSpacing)-[button3]"
        let horizontalConstraints = NSLayoutConstraint.constraints(withVisualFormat: descHorizontal,
                                                                   options: .alignAllCenterY,
                                                                   metrics: metrics,
                                                                   views: viewsDict)
        let verticalConstraints1 = NSLayoutConstraint.constraints(withVisualFormat: descVertical1,
                                                                 options: .alignAllCenterY,
                                                                 metrics: metrics,
                                                                 views: viewsDict)
        let verticalConstraints2 = NSLayoutConstraint.constraints(withVisualFormat: descVertical2,
                                                                 options: NSLayoutFormatOptions(rawValue: 0),
                                                                 metrics: metrics,
                                                                 views: viewsDict)
        let verticalConstraints3 = NSLayoutConstraint.constraints(withVisualFormat: descVertical3,
                                                                 options: NSLayoutFormatOptions(rawValue: 0),
                                                                 metrics: metrics,
                                                                 views: viewsDict)
        
        let viewHorizontal = "H:|-[myView]-|"
        let viewVeritical = "V:[button1]-(==viewVerticalSpace)-[myView]-(==viewVerticalSpace)-|"
        let viewHorizontalConstraint = NSLayoutConstraint.constraints(withVisualFormat: viewHorizontal,
                                                                      options: NSLayoutFormatOptions(rawValue:0),
                                                                      metrics: metrics,
                                                                      views: viewsDict)
        
        let viewVerticalConstraint = NSLayoutConstraint.constraints(withVisualFormat: viewVeritical,
                                                                      options: NSLayoutFormatOptions(rawValue:0),
                                                                      metrics: metrics,
                                                                      views: viewsDict)
        self.view.addConstraints(horizontalConstraints)
        self.view.addConstraints(verticalConstraints1)
        self.view.addConstraints(verticalConstraints2)
        self.view.addConstraints(verticalConstraints3)
        self.view.addConstraints(viewHorizontalConstraint)
        self.view.addConstraints(viewVerticalConstraint)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func buttonPressed(_ sender: AnyObject) {
        
        let myView = ShapeView(frame:CGRect(x: 25, y: 200, width: 280, height: 250) , shape: sender.tag)
        myView.backgroundColor = UIColor.cyan
        view.addSubview(myView)
    }


}

