//
//  ToDoItem.swift
//  UIGestureRecognizerApp
//
//  Created by zhen gong on 6/3/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

class ToDoItem: NSObject {
    
    var text:String
    
    var completed:Bool
    
    init(text:String) {
        self.text = text
        self.completed = false
    }

}
