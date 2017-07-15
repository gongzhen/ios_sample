//
//  ViewController.swift
//  SwiftEvent
//
//  Created by zhen gong on 7/5/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let event = Event<(String, String)>()
        let handler = event.addHandler(target: self, handler: ViewController.handlerEvent)
        event.raise(data: ("Chris", "Gong"))
        handler.dispose()
    }
    
    func handlerEvent(data:(String, String)) {
        print("Hello \(data.0), \(data.1)")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

