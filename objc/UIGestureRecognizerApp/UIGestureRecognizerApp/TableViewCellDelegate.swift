
//
//  TableViewCellDelegate.swift
//  UIGestureRecognizerApp
//
//  Created by zhen gong on 6/3/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import Foundation

protocol TableViewCellDelegate {
    // indicates that the given item has been deleted
    func toDoItemDeleted(_ todoItem: ToDoItem)
}
