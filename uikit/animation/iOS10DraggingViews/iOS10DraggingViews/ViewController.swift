//
//  ViewController.swift
//  iOS10DraggingViews
//
//  Created by zhen gong on 6/21/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var view1:UIView!
    
//    var view2:UIView!
//    
//    var view3:UIView!
    
    private func createView() -> UIView {
        let view = MyView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.cyan
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view1 = createView()
//        view2 = createView()
//        view3 = createView()
        view.backgroundColor = UIColor.white
        view.addSubview(view1)
//        view.addSubview(view2)
//        view.addSubview(view3)
        
        view1.widthAnchor.constraint(equalToConstant: 200).isActive = true
        view1.heightAnchor.constraint(equalToConstant: 200).isActive = true
        view1.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        view1.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

