
//
//  TableViewCellDelegate.swift
//  UIGestureRecognizerApp
//
//  Created by zhen gong on 6/3/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import Foundation

protocol TableViewCellDelegate {
    func toDoItemDeleted(_ todoItem: ToDoItem)
    // Indicates that the edit process has begun for the given cell
    func cellDidBeginEditing(_ editingCell: TableViewCell)
    // Indicates that the edit process has committed for the given cell
    func cellDidEndEditing(_ editingCell: TableViewCell)
}
