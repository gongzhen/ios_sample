//
//  ChocolateButton.swift
//  RxSwift-1
//
//  Created by ULS on 4/3/18.
//  Copyright © 2018 ULS. All rights reserved.
//

import UIKit


@IBDesignable
class ChocolateButton: UIButton {
    
    override var isEnabled: Bool {
        didSet {
            updateAlphaForEnabledState()
        }
    }
    
    enum ButtonType {
        case Standard, Warning
    }
    
    @IBInspectable var isStandard: Bool = false {
        didSet {
            if isStandard {
                self.type = .Standard
            } else {
                self.type = .Warning
            }
        }
    }
    
    private var type: ButtonType = .Standard {
        didSet {
            updateBackgroundColorForCurrentType()
        }
    }
    
    //MARK: INITIALIZATION
    
    private func commonInit() {
        self.setTitleColor(UIColor.white, for: .normal)
        updateBackgroundColorForCurrentType()
        updateAlphaForEnabledState()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        commonInit()
    }
    
    func updateBackgroundColorForCurrentType() {
        switch type {
        case .Standard:
            self.backgroundColor = UIColor.brown
        case .Warning:
            self.backgroundColor = UIColor.red
        }
    }
    
    func updateAlphaForEnabledState() {
        if isEnabled {
            self.alpha = 1
        } else {
            self.alpha = 0.5
        }
    }

}
