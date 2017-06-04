//
//  ViewController.swift
//  UIGestureRecognizerApp
//
//  Created by zhen gong on 6/3/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TableViewCellDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var toDoItems = [ToDoItem]()
    let pinchRecognizer = UIPinchGestureRecognizer()
    
    // the indices of the upper and lower cells that are being pinched
    var upperCellIndex = -100
    var lowerCellIndex = -100
    // the location of the touch points when the pinch began
    var initialTouchPoints: TouchPoints!
    // indicates that the pinch was big enough to cause a new item to be added
    var pinchExceededRequiredDistance = false
    
    // indicates that the pinch is in progress
    var pinchInProgress = false
    
    // MARK: - UIScrollViewDelegate methods
    // contains scrollViewDidScroll, and you'll add two more, to keep track of dragging the scrollView
    
    // a cell that is rendered as a placeholder to indicate where a new item is added
    let placeHolderCell = TableViewCell(style: .default, reuseIdentifier: "cell")
    // indicates the state of this behavior
    var pullDownInProgress = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        pinchRecognizer.addTarget(self, action: #selector(ViewController.handlePinch(_:)))
        tableView.addGestureRecognizer(pinchRecognizer)
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor.black
        tableView.rowHeight = 50;
        
        if toDoItems.count > 0 {
            return
        }
        toDoItems.append(ToDoItem(text: "feed the cat"))
        toDoItems.append(ToDoItem(text: "buy eggs"))
        toDoItems.append(ToDoItem(text: "watch WWDC videos"))
        toDoItems.append(ToDoItem(text: "rule the Web"))
        toDoItems.append(ToDoItem(text: "buy a new iPhone"))
        toDoItems.append(ToDoItem(text: "darn holes in socks"))
        toDoItems.append(ToDoItem(text: "write this tutorial"))
        toDoItems.append(ToDoItem(text: "master Swift"))
        toDoItems.append(ToDoItem(text: "learn to draw"))
        toDoItems.append(ToDoItem(text: "get more exercise"))
        toDoItems.append(ToDoItem(text: "catch up with Mom"))
        toDoItems.append(ToDoItem(text: "get a hair cut"))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


extension ViewController {
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoItems.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TableViewCell
        //            cell.textLabel?.backgroundColor = UIColor.clearColor()
        
        cell.selectionStyle = .none
        let item = toDoItems[indexPath.row]
        //            cell.textLabel?.text = item.text
        cell.delegate = self
        cell.toDoItem = item
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.backgroundColor = colorForIndex(indexPath.row)
    }
    
    fileprivate func colorForIndex(_ index:Int) -> UIColor {
        let itemCount = toDoItems.count - 1
        let val = (CGFloat(index) / CGFloat(itemCount)) * 0.6
        return UIColor(red: 1.0, green: val, blue: 0.0, alpha: 1.0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return LayoutConstant.kRowHeight
    }
    
}

extension ViewController {
    func toDoItemDeleted(_ toDoItem: ToDoItem) {
        // could use this to get index when Swift Array indexOfObject works
        // let index = toDoItems.indexOfObject(toDoItem)
        // in the meantime, scan the array to find index of item to delete
        var index = 0
        for i in 0..<toDoItems.count {
            if toDoItems[i] === toDoItem {  // note: === not ==
                index = i
                break
            }
        }
        // could removeAtIndex in the loop but keep it here for when indexOfObject works
        toDoItems.remove(at: index)
        
        // loop over the visible cells to animate delete
        let visibleCells = tableView.visibleCells as! [TableViewCell]
        let lastView = visibleCells[visibleCells.count - 1] as TableViewCell
        var delay = 0.0
        var startAnimating = false
        for i in 0..<visibleCells.count {
            let cell = visibleCells[i]
            if startAnimating {
                UIView.animate(withDuration: 0.3, delay: delay, options: [.curveEaseInOut],
                               animations: {() in
                                cell.frame = cell.frame.offsetBy(dx: 0.0, dy: -cell.frame.size.height)},
                               completion: {(finished: Bool) in if (cell == lastView) {
                                self.tableView.reloadData()
                                }
                    }
                )
                delay += 0.03
            }
            if cell.toDoItem === toDoItem {
                startAnimating = true
                cell.isHidden = true
            }
        }
        
        tableView.beginUpdates()
        let indexPathForRow = IndexPath(row: index, section: 0)
        tableView.deleteRows(at: [indexPathForRow], with: .fade)
        tableView.endUpdates()
    }
    
    func cellDidBeginEditing(_ editingCell: TableViewCell) {
        let editingOffset = tableView.contentOffset.y - editingCell.frame.origin.y as CGFloat
        let visibleCells = tableView.visibleCells as! [TableViewCell]
        for cell in visibleCells {
            UIView.animate(withDuration: 0.3, animations: {() in
                cell.transform = CGAffineTransform(translationX: 0, y: editingOffset)
                if cell !== editingCell {
                    cell.alpha = 0.3
                }
            })
        }
    }
    
    func cellDidEndEditing(_ editingCell: TableViewCell) {
        let visibleCells = tableView.visibleCells as! [TableViewCell]
        for cell: TableViewCell in visibleCells {
            UIView.animate(withDuration: 0.3, animations: {() in
                cell.transform = CGAffineTransform.identity
                if cell !== editingCell {
                    cell.alpha = 1.0
                }
            })
        }
        if editingCell.toDoItem!.text == "" {
            toDoItemDeleted(editingCell.toDoItem!)
        }
    }
}

extension ViewController {

    struct TouchPoints {
        var upper: CGPoint
        var lower: CGPoint
    }
    
    func handlePinch(_ recognizer: UIPinchGestureRecognizer) {
        if recognizer.state == .began {
            pinchStarted(recognizer)
        }
        if recognizer.state == .changed
            && pinchInProgress
            && recognizer.numberOfTouches == 2 {
            pinchChanged(recognizer)
        }
        if recognizer.state == .ended {
            pinchEnded(recognizer)
        }
    }
    
    func pinchStarted(_ recognizer: UIPinchGestureRecognizer) {
        // find the touch-points
        initialTouchPoints = getNormalizedTouchPoints(recognizer)
        print("initialTouchPoints:\(initialTouchPoints)")
        
        // locate the cells that these points touch
        upperCellIndex = -100
        lowerCellIndex = -100
        let visibleCells = tableView.visibleCells as! [TableViewCell]
        for i in 0..<visibleCells.count {
            let cell = visibleCells[i]
            if viewContainsPoint(cell, point: initialTouchPoints.upper) {
                upperCellIndex = i
            }
            if viewContainsPoint(cell, point: initialTouchPoints.lower) {
                lowerCellIndex = i
            }
        }
        // check whether they are neighbors
        if abs(upperCellIndex - lowerCellIndex) == 1 {
            // initiate the pinch
            pinchInProgress = true
            // show placeholder cell
            let precedingCell = visibleCells[upperCellIndex]
            placeHolderCell.frame = (precedingCell.frame).offsetBy(dx: 0.0, dy: LayoutConstant.kRowHeight / 2.0)
            placeHolderCell.backgroundColor = precedingCell.backgroundColor
            tableView.insertSubview(placeHolderCell, at: 0)
        }
    }
    
    func pinchChanged(_ recognizer: UIPinchGestureRecognizer) {
        // find the touch points
        let currentTouchPoints = getNormalizedTouchPoints(recognizer)
        print("currentTouchPoints:\(currentTouchPoints)")
        // determine by how much each touch point has changed, and take the minimum delta
        let upperDelta = currentTouchPoints.upper.y - initialTouchPoints.upper.y
        print("currentTouchPoints.upper.y:\(currentTouchPoints.upper.y)")
        
        let lowerDelta = initialTouchPoints.lower.y - currentTouchPoints.lower.y
        let delta = -min(0, min(upperDelta, lowerDelta))
        
        // offset the cells, negative for the cells above, positive for those below
        let visibleCells = tableView.visibleCells as! [TableViewCell]
        for i in 0..<visibleCells.count {
            let cell = visibleCells[i]
            if i <= upperCellIndex {
                cell.transform = CGAffineTransform(translationX: 0, y: -delta)
            }
            if i >= lowerCellIndex {
                cell.transform = CGAffineTransform(translationX: 0, y: delta)
            }
        }
        
        // scale the placeholder cell
        let gapSize = delta * 2
        let cappedGapSize = min(gapSize, tableView.rowHeight)
        placeHolderCell.transform = CGAffineTransform(scaleX: 1.0, y: cappedGapSize / tableView.rowHeight)
        placeHolderCell.strikeTextField.text = gapSize > tableView.rowHeight ? "Release to add item" : "Pull apart to add item"
        placeHolderCell.alpha = min(1.0, gapSize / tableView.rowHeight)
        
        // has the user pinched far enough?
        pinchExceededRequiredDistance = gapSize > tableView.rowHeight
    }
    
    func pinchEnded(_ recognizer: UIPinchGestureRecognizer) {
        self.pinchInProgress = false
        
        // remove the placeholder cell
        placeHolderCell.transform = CGAffineTransform.identity
        placeHolderCell.removeFromSuperview()
        
        if pinchExceededRequiredDistance {
            pinchExceededRequiredDistance = false
            
            // Set all the cells back to the transform identity
            let visibleCells = self.tableView.visibleCells as! [TableViewCell]
            for cell in visibleCells {
                cell.transform = CGAffineTransform.identity
            }
            
            // add a new item
            let indexOffset = Int(floor(tableView.contentOffset.y / tableView.rowHeight))
            toDoItemAddedAtIndex(lowerCellIndex + indexOffset)
        } else {
            // otherwise, animate back to position
            UIView.animate(withDuration: 0.2, delay: 0.0, options: UIViewAnimationOptions(), animations: {() in
                let visibleCells = self.tableView.visibleCells as! [TableViewCell]
                for cell in visibleCells {
                    cell.transform = CGAffineTransform.identity
                }
            }, completion: nil)
        }
    }
    
    // returns the two touch points, ordering them to ensure that
    // upper and lower are correctly identified.
    fileprivate func getNormalizedTouchPoints(_ recognizer: UIGestureRecognizer) -> TouchPoints {
        var pointOne = recognizer.location(ofTouch: 0, in: tableView)
        var pointTwo = recognizer.location(ofTouch: 1, in: tableView)
        // ensure pointOne is the top-most
        if pointOne.y > pointTwo.y {
            let temp = pointOne
            pointOne = pointTwo
            pointTwo = temp
        }
        return TouchPoints(upper: pointOne, lower: pointTwo)
    }
    
    fileprivate func viewContainsPoint(_ view: UIView, point: CGPoint) -> Bool {
        let frame = view.frame
        return (frame.origin.y < point.y) && (frame.origin.y + (frame.size.height) > point.y)
    }
    
}

// MARK: - UIScrollViewDelegate methods
// contains scrollViewDidScroll, and you'll add two more, to keep track of dragging the scrollView
extension ViewController {
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        // this behavior starts when a user pulls down while at the top of the table
        self.pullDownInProgress = scrollView.contentOffset.y <= 0.0
        placeHolderCell.backgroundColor = UIColor.red
        if self.pullDownInProgress {
            // add the placeholder
            tableView.insertSubview(placeHolderCell, at: 0)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView)  {
        // non-scrollViewDelegate methods need this property value
        let scrollViewContentOffsetY = tableView.contentOffset.y
        
        if pullDownInProgress && scrollView.contentOffset.y <= 0.0 {
            // maintain the location of the placeholder
            placeHolderCell.frame = CGRect(x: 0, y: -tableView.rowHeight,
                                           width: tableView.frame.size.width, height: tableView.rowHeight)
            placeHolderCell.strikeTextField.text = -scrollViewContentOffsetY > tableView.rowHeight ?
                "Release to add item" : "Pull to add item"
            placeHolderCell.alpha = min(1.0, -scrollViewContentOffsetY / tableView.rowHeight)
        } else {
            pullDownInProgress = false
        }        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        // check whether the user pulled down far enough
        if pullDownInProgress && -scrollView.contentOffset.y > tableView.rowHeight {
            toDoItemAdded()
        }
        pullDownInProgress = false
        placeHolderCell.removeFromSuperview()
    }
    
    // MARK: - add, delete, edit methods
    
    func toDoItemAdded() {
        toDoItemAddedAtIndex(0)
    }
    
    func toDoItemAddedAtIndex(_ index: Int) {
        let toDoItem = ToDoItem(text: "")
        toDoItems.insert(toDoItem, at: index)
        tableView.reloadData()
        // enter edit mode
        var editCell: TableViewCell
        let visibleCells = tableView.visibleCells as! [TableViewCell]
        for cell in visibleCells {
            if (cell.toDoItem === toDoItem) {
                editCell = cell
                editCell.strikeTextField.becomeFirstResponder()
                break
            }
        }
    }
}
