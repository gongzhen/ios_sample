//
//  AttributeCell.swift
//  TableViewMultipleCellMVVMSwift
//
//  Created by Admin  on 9/26/17.
//  Copyright © 2017 Admin . All rights reserved.
//

import UIKit

class AttributeCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    
    var item: Attribute? {
        didSet {
            titleLabel.text = item?.key
            valueLabel.text = item?.value
        }
    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier:String {
        return String(describing: self)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
