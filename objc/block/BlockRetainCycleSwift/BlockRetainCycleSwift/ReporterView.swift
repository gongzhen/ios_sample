//
//  ReporterView.swift
//  BlockRetainCycleSwift
//
//  Created by zhen gong on 6/12/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

class ReporterView: UIView {
    
    var doBlock:(() -> ())?
    
    var bobClosure:(() -> ())?
    var bobName: String = {
        return "Bob"
    }()
    
    init() {
        super.init(frame: CGRect.zero)
        self.bobClosure = {
//            print("bobClosure \(self.bobName)")
        }
        NotificationCenter.default.addObserver(self, selector: #selector(handleNotification), name: NSNotification.Name(rawValue: "Notification"), object: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    
    func block(closureBlock:@escaping ((Void) -> (Void))) {
        self.doBlock = closureBlock
        if let doBlock = self.doBlock {
            print("ReporterView call block method:\(self.bobName)")
            doBlock()
        }
        
    }
    
    func foo() {
        NSLog("Foo is called")
    }
    
    func handleNotification() {
        NSLog("Notification Received")
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
        NSLog("dealloc")
    }

}
