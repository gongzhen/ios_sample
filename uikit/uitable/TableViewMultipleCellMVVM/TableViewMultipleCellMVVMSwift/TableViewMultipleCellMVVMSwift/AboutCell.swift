//
//  AboutCell.swift
//  TableViewMultipleCellMVVMSwift
//
//  Created by Admin  on 9/25/17.
//  Copyright © 2017 Admin . All rights reserved.
//

import UIKit

class AboutCell: UITableViewCell {

    @IBOutlet weak var aboutLabel: UILabel!
    
    var item:ProfileViewModelItem? {
        didSet {
            guard let item = item as? ProfileViewModelAboutItem else {
                return
            }
            
            aboutLabel.text = item.about
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    static var nib: UINib {
        return UINib(nibName: identifier, bundle: nil)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
}
