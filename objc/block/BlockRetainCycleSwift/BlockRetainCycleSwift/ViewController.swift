//
//  ViewController.swift
//  BlockRetainCycleSwift
//
//  Created by zhen gong on 6/12/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//  https://swiftcafe.io/2017/02/02/weak-block/

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        var reportView:ReporterView?
        reportView  = ReporterView()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "Notification"), object: nil)
        reportView!.block(closureBlock: {
            reportView!.foo()
        })
        reportView = nil
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { 
            NSLog("After 5 seconds.... ViewController notification will be received.")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue:"Notification"), object: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

