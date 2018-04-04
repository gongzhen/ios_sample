//
//  ValidatingTextField.swift
//  RxSwift-1
//
//  Created by ULS on 4/3/18.
//  Copyright © 2018 ULS. All rights reserved.
//

import UIKit

class ValidatingTextField: UITextField {
    
    var hasBeenExited: Bool = false {
        didSet {
            configureForValid()
        }
    }
    
    var valid:Bool = false {
        didSet {
            configureForValid()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func resignFirstResponder() -> Bool {
        hasBeenExited = true
        return super.resignFirstResponder()
    }
    
    func commonInit() {
        configureForValid()
    }
    
    private func configureForValid() {
        if !valid && hasBeenExited {
            //Only color the background if the user has tried to
            //input things at least once.
            self.backgroundColor = .red
        } else {
            self.backgroundColor = .clear
        }
    }

}
