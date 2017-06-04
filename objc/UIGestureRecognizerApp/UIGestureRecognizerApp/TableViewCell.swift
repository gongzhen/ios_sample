//
//  TableViewCell.swift
//  UIGestureRecognizerApp
//
//  Created by zhen gong on 6/3/17.
//  Copyright © 2017 zhen gong. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    var gradientLayer = GradientLayer()
    var originalCenter = CGPoint()
    var deleteOnDragRelease = false, completeOnDragRelease = false
    var tickLabel = TickLabel()
    var crossLabel = CrossLabel()
    let strikeLabel = StrikeThroughTextLabel()
    
    var itemCompleteLayer = BaseLayer()
    // The object that acts as delegate for this cell.
    var delegate: TableViewCellDelegate?
    // The item that this cell renders.
    var toDoItem: ToDoItem? {
        didSet {
            strikeLabel.text = toDoItem!.text
            strikeLabel.strikeThrough = toDoItem!.completed
            itemCompleteLayer.isHidden = !strikeLabel.strikeThrough
        }
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        _setup()
    }
    
    fileprivate func _setup() {
        self.selectionStyle = .none
        self.addSubview(self.tickLabel)
        self.addSubview(self.crossLabel)
        self.addSubview(self.strikeLabel)
        self.gradientLayer.frame = self.bounds
        self.layer.insertSublayer(gradientLayer, at: 0)
        
        self.itemCompleteLayer = BaseLayer(layer: layer)
        layer.insertSublayer(self.itemCompleteLayer, at: 0)
        
        let recognizer = UIPanGestureRecognizer(target: self, action: #selector(TableViewCell.handlePan(_:)))
        recognizer.delegate = self
        addGestureRecognizer(recognizer)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // ensure the gradient layer occupies the full bounds
        gradientLayer.frame = bounds
        itemCompleteLayer.frame = bounds
        strikeLabel.frame = CGRect(x: LayoutConstant.kLabelLeftMargin, y: 0,
                             width: bounds.size.width - LayoutConstant.kLabelLeftMargin, height: bounds.size.height)
        tickLabel.frame = CGRect(x: -LayoutConstant.kUICuesWidth - LayoutConstant.kUICuesMargin, y: 0,
                                 width: LayoutConstant.kUICuesWidth, height: bounds.size.height)
        crossLabel.frame = CGRect(x: bounds.size.width + LayoutConstant.kUICuesMargin, y: 0,
                                  width: LayoutConstant.kUICuesWidth, height: bounds.size.height)
    }
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: - horizontal pan gesture methods
    func handlePan(_ recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:
            // when the gesture begins, record the current center location
            originalCenter = center
            
            break
        case .changed:
            let translation = recognizer.translation(in: self)
            // Find the center point which is center + translation offset.
            center = CGPoint(x: originalCenter.x + translation.x, y: originalCenter.y)
            // has the user dragged the item far enough to initiate a delete/complete?
            deleteOnDragRelease = frame.origin.x < -frame.size.width / 2.0
            completeOnDragRelease = frame.origin.x > frame.size.width / 2.0
            // fade the contextual clues
            let cueAlpha = fabs(frame.origin.x) / (frame.size.width / 2.0)
            tickLabel.alpha = cueAlpha
            crossLabel.alpha = cueAlpha
            // indicate when the user has pulled the item far enough to invoke the given action
            tickLabel.textColor = completeOnDragRelease ? UIColor.green : UIColor.white
            crossLabel.textColor = deleteOnDragRelease ? UIColor.red : UIColor.white
            break
        case .ended:
            let originalFrame = CGRect(x: 0, y: frame.origin.y,
                                       width: bounds.size.width, height: bounds.size.height)
            if deleteOnDragRelease {
                if delegate != nil && toDoItem != nil {
                    // notify the delegate that this item should be deleted
                    delegate!.toDoItemDeleted(toDoItem!)
                }
            } else if completeOnDragRelease {
                if toDoItem != nil {
                    toDoItem!.completed = true
                }
                strikeLabel.strikeThrough = true
                itemCompleteLayer.isHidden = false
                UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
            } else {
                UIView.animate(withDuration: 0.2, animations: {self.frame = originalFrame})
            }
            break
        default:
            break
        }
    }

}
