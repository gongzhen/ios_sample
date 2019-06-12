//
//  ViewController.swift
//  LearnRxFrameworkSwift
//
//  Created by Zhen Gong on 5/19/19.
//  Copyright © 2019 Zhen Gong. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // let main = MainProtocol()
//        let main = MainClosure()
//        let main = CarWithClosureObjC()
//        let main = MainWrapper()
//        let main = MainAutomaticWrapper()
        let main = CarWithAutomaticWrapperObjC();
        main.main()
    }


}

